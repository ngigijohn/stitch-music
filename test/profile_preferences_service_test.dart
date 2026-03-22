import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/services/profile_preferences_service.dart';

void main() {
  test('profile preferences persist local display fields', () async {
    SharedPreferences.setMockInitialValues({});
    final service = ProfilePreferencesService.instance;

    await service.init();
    await service.saveProfile(displayName: 'DJ Local', email: 'dj@local.test');

    expect(service.displayName, 'DJ Local');
    expect(service.email, 'dj@local.test');
  });
}