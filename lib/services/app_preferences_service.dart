import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLocaleCode = 'app_locale_code';
const String _kHighContrast = 'app_high_contrast';
const String _kTextScale = 'app_text_scale';

class AppPreferencesService extends ChangeNotifier {
  AppPreferencesService._();

  static final AppPreferencesService instance = AppPreferencesService._();

  bool _initialized = false;
  String? _localeCode;
  bool _highContrast = false;
  double _textScale = 1.0;

  String? get localeCode => _localeCode;
  bool get highContrast => _highContrast;
  double get textScale => _textScale;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _load();
  }

  Future<void> setLocaleCode(String? code) async {
    _localeCode = code;
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_kLocaleCode);
    } else {
      await prefs.setString(_kLocaleCode, code);
    }
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHighContrast, value);
    notifyListeners();
  }

  Future<void> setTextScale(double value) async {
    final normalized = value.clamp(0.9, 1.4).toDouble();
    _textScale = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kTextScale, normalized);
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _localeCode = prefs.getString(_kLocaleCode);
    _highContrast = prefs.getBool(_kHighContrast) ?? false;
    _textScale = prefs.getDouble(_kTextScale) ?? 1.0;
    notifyListeners();
  }
}
