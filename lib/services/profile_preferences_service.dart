import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kProfileDisplayName = 'profile_display_name';
const String _kProfileEmail = 'profile_email';

class ProfilePreferencesService extends ChangeNotifier {
  ProfilePreferencesService._();

  static final ProfilePreferencesService instance = ProfilePreferencesService._();

  bool _initialized = false;
  String _displayName = 'Music Lover';
  String _email = 'listener@stitchmusic.app';

  String get displayName => _displayName;
  String get email => _email;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _load();
  }

  Future<void> saveProfile({
    required String displayName,
    required String email,
  }) async {
    _displayName = displayName.trim().isEmpty ? 'Music Lover' : displayName.trim();
    _email = email.trim().isEmpty ? 'listener@stitchmusic.app' : email.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfileDisplayName, _displayName);
    await prefs.setString(_kProfileEmail, _email);
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _displayName = prefs.getString(_kProfileDisplayName) ?? _displayName;
    _email = prefs.getString(_kProfileEmail) ?? _email;
    notifyListeners();
  }
}