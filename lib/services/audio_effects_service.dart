import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Persistence keys ─────────────────────────────────────────────────────────
const _kActivePreset  = 'v1_eq_active_preset';
const _kCustomBands   = 'v1_eq_custom_bands';
const _kEqEnabled     = 'v1_eq_enabled';

// ─── Band frequencies ─────────────────────────────────────────────────────────

/// Five standard bands covering the full audible spectrum.
const List<int> kEqBandHz = [60, 230, 910, 3600, 14000];
const List<String> kEqBandLabels = ['60Hz', '230Hz', '910Hz', '3.6kHz', '14kHz'];

// ─── Models ───────────────────────────────────────────────────────────────────

/// EQ gains in dB for each of the five bands. Range: -12 to +12.
class EqualizerBands {
  final List<double> gains; // length == 5

  const EqualizerBands(this.gains);

  static const flat = EqualizerBands([0, 0, 0, 0, 0]);

  EqualizerBands copyWith(int bandIndex, double gain) {
    final next = List<double>.from(gains);
    next[bandIndex] = gain.clamp(-12.0, 12.0);
    return EqualizerBands(next);
  }

  Map<String, dynamic> toJson() => {'gains': gains};

  factory EqualizerBands.fromJson(Map<String, dynamic> j) {
    final raw = (j['gains'] as List).map((v) => (v as num).toDouble()).toList();
    if (raw.length != 5) return flat;
    return EqualizerBands(raw);
  }
}

enum EqPresetId { normal, bassBoost, trebleBoost, vocalClarity, custom }

class EqPreset {
  final EqPresetId id;
  final String name;
  final EqualizerBands bands;

  const EqPreset({required this.id, required this.name, required this.bands});
}

// ─── Built-in presets ─────────────────────────────────────────────────────────

const List<EqPreset> kBuiltinPresets = [
  EqPreset(
    id: EqPresetId.normal,
    name: 'Normal',
    bands: EqualizerBands.flat,
  ),
  EqPreset(
    id: EqPresetId.bassBoost,
    name: 'Bass Boost',
    bands: EqualizerBands([6, 5, 0, -1, -1]),
  ),
  EqPreset(
    id: EqPresetId.trebleBoost,
    name: 'Treble Boost',
    bands: EqualizerBands([-1, -1, 0, 5, 6]),
  ),
  EqPreset(
    id: EqPresetId.vocalClarity,
    name: 'Vocal Clarity',
    bands: EqualizerBands([-2, 0, 4, 4, 2]),
  ),
  EqPreset(
    id: EqPresetId.custom,
    name: 'Custom',
    bands: EqualizerBands.flat,
  ),
];

// ─── Service ──────────────────────────────────────────────────────────────────

/// Manages EQ state and persists it across sessions.
///
/// Note: actual DSP audio processing requires a native plugin such as
/// `just_audio_equalizer` or the Android AudioEffect API. This service
/// owns the state and exposes a [onBandsChanged] callback so the audio
/// pipeline layer can apply gains when that integration is added.
class AudioEffectsService extends ChangeNotifier {
  AudioEffectsService._();
  static final AudioEffectsService instance = AudioEffectsService._();

  bool _enabled = true;
  EqPresetId _activePresetId = EqPresetId.normal;
  EqualizerBands _customBands = EqualizerBands.flat;
  bool _initialized = false;

  // ── Accessors ─────────────────────────────────────────────────────────────

  bool get isEnabled => _enabled;
  EqPresetId get activePresetId => _activePresetId;

  EqPreset get activePreset =>
      kBuiltinPresets.firstWhere((p) => p.id == _activePresetId);

  /// The bands currently in effect (custom if preset == custom, else preset bands).
  EqualizerBands get activeBands =>
      _activePresetId == EqPresetId.custom ? _customBands : activePreset.bands;

  EqualizerBands get customBands => _customBands;

  List<EqPreset> get allPresets => kBuiltinPresets;

  // ── Mutation ───────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _load();
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
    await _save();
  }

  Future<void> selectPreset(EqPresetId id) async {
    if (_activePresetId == id) return;
    _activePresetId = id;
    notifyListeners();
    await _save();
  }

  /// Move a single custom band. Automatically switches to Custom preset.
  Future<void> setCustomBand(int bandIndex, double gainDb) async {
    _customBands = _customBands.copyWith(bandIndex, gainDb);
    _activePresetId = EqPresetId.custom;
    notifyListeners();
    await _save();
  }

  Future<void> resetToFlat() async {
    _customBands = EqualizerBands.flat;
    _activePresetId = EqPresetId.normal;
    notifyListeners();
    await _save();
  }

  // ── Persistence ───────────────────────────────────────────────────────────

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool(_kEqEnabled) ?? true;
      final presetName = prefs.getString(_kActivePreset);
      if (presetName != null) {
        _activePresetId = EqPresetId.values.firstWhere(
          (e) => e.name == presetName,
          orElse: () => EqPresetId.normal,
        );
      }
      final bandsJson = prefs.getString(_kCustomBands);
      if (bandsJson != null) {
        _customBands = EqualizerBands.fromJson(
            jsonDecode(bandsJson) as Map<String, dynamic>);
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kEqEnabled, _enabled);
      await prefs.setString(_kActivePreset, _activePresetId.name);
      await prefs.setString(
          _kCustomBands, jsonEncode(_customBands.toJson()));
    } catch (_) {}
  }
}
