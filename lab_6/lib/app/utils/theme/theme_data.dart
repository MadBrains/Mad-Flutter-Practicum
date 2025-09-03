import 'package:flutter/material.dart';

part 'theme_colors.dart';

part 'theme_fonts.dart';

extension ThemeExt on ThemeData {
  ThemeData get appThemeData {
    final AppThemeData appThemeData = AppThemeData(brightness: brightness);
    final ThemeColors colors = appThemeData.themeColors;
    final ThemeFonts fonts = appThemeData.themeFonts;

    return copyWith(
      scaffoldBackgroundColor: colors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBarBackground,
        titleTextStyle: fonts.regular16.copyWith(color: colors.secondary),
        centerTitle: true,
        surfaceTintColor: colors.appBarSurfaceTint,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.bottomNavBarBackground,
        selectedItemColor: colors.bottomNavBarSelectedItem,
        unselectedItemColor: colors.bottomNavBarUnselectedItem,
        selectedLabelStyle: fonts.regular12.copyWith(color: colors.blueDepression),
        unselectedLabelStyle: fonts.regular12.copyWith(color: colors.platinumGranite),
      ),
      textTheme: TextTheme(
        bodyLarge: fonts.semiBold12.copyWith(color: colors.secondary),
        bodyMedium: fonts.regular12.copyWith(color: colors.secondary),
        bodySmall: fonts.regular12.copyWith(color: colors.tin),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: fonts.regular12.copyWith(color: colors.stormyGrey),
        border: _textFieldBorderFromColor(colors.grey),
        enabledBorder: _textFieldBorderFromColor(colors.grey),
        focusedBorder: _textFieldBorderFromColor(colors.secondary),
      ),
      extensions: <ThemeExtension<dynamic>>[appThemeData],
    );
  }

  static InputBorder _textFieldBorderFromColor(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: color),
      );
}

class AppThemeData extends ThemeExtension<AppThemeData> {
  factory AppThemeData({required final Brightness brightness}) {
    final bool isDark = brightness == Brightness.dark;

    final ThemeColors themeColors = isDark ? ThemeColors.dark() : ThemeColors.light();
    final ThemeFonts themeFonts = ThemeFonts(color: isDark ? themeColors.white : themeColors.black);

    return AppThemeData.raw(brightness: brightness, themeFonts: themeFonts, themeColors: themeColors);
  }

  factory AppThemeData.light() => AppThemeData(brightness: Brightness.light);

  factory AppThemeData.dark() => AppThemeData(brightness: Brightness.dark);

  const AppThemeData.raw({required this.brightness, required this.themeFonts, required this.themeColors});

  final Brightness brightness;
  final ThemeFonts themeFonts;
  final ThemeColors themeColors;

  @override
  AppThemeData copyWith({
    final Brightness? brightness,
    final ThemeFonts? themeFonts,
    final ThemeColors? themeColors,
  }) {
    return AppThemeData.raw(
      brightness: brightness ?? this.brightness,
      themeFonts: themeFonts ?? this.themeFonts,
      themeColors: themeColors ?? this.themeColors,
    );
  }

  @override
  AppThemeData lerp(ThemeExtension<AppThemeData>? other, double t) {
    if (other is! AppThemeData) {
      return this;
    }

    return copyWith(
      themeFonts: themeFonts.lerp(other.themeFonts, t),
      themeColors: themeColors.lerp(other.themeColors, t),
    );
  }
}
