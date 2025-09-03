import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';

final _cachedTheme = AppThemeData.light();

extension ThemeContextExtension on BuildContext {
  AppThemeData get theme => Theme.of(this).extension<AppThemeData>() ?? _cachedTheme;

  ThemeColors get colors => theme.themeColors;

  ThemeFonts get fonts => theme.themeFonts;
}
