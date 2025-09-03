import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

extension NullableAppThemeModeExt on AppThemeMode? {
  ThemeMode get themeMode => switch (this) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        (_) => ThemeMode.system,
      };
}

extension AppThemeModeExt on AppThemeMode {
  String get title => switch (this) {
        AppThemeMode.light => 'Светлая',
        AppThemeMode.dark => 'Тёмная',
        AppThemeMode.system => 'Системная',
      };
}
