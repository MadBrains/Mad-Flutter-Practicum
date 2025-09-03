import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/mapper/app_theme_mode_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/model/app_theme_mode_dao.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

void main() {
  void run(String? input, AppThemeMode expectedMode) {
    test('AppThemeModeDao.fromString("$input") should map to $expectedMode', () {
      final AppThemeModeDao mode = AppThemeModeDao.fromString(input);

      final result = mode.model;

      expect(result, expectedMode);
    });
  }

  group('AppThemeModeDao.fromString mapping tests', () {
    for (final mode in AppThemeMode.values) {
      run(mode.name, mode);
    }

    run(null, AppThemeMode.system);
  });
}
