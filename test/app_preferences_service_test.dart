import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/services/app_preferences_service.dart';

void main() {
  test('app preferences persist locale and contrast options', () async {
    SharedPreferences.setMockInitialValues({});
    final service = AppPreferencesService.instance;

    await service.init();
    await service.setLocaleCode('es');
    await service.setHighContrast(true);

    expect(service.localeCode, 'es');
    expect(service.highContrast, isTrue);
  });
}
