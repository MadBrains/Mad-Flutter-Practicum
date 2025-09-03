part of 'theme_data.dart';

abstract class _AppColors {
  static const transparent = Colors.transparent;
  static const white = Colors.white;
  static const black = Colors.black;
  static const black25 = Color(0x40000000);
  static const grey = Colors.grey;
  static const red = Colors.red;

  static const stormyGrey = Color(0xFF7C7B7B);
  static const blueDepression = Color(0xFF3929C7);
  static const bleachedSilk = Color(0xFFF2F2F2);
  static const platinumGranite = Color(0xFF7F7F7F);
  static const tin = Color(0xFF909090);
  static const dynamicBlack = Color(0xFF1E1E1E);
  static const bluePartyParrot = Color(0xFF857BFD);
  static const dartToneInk = Color(0xFF121212);
  static const palladium = Color(0xFFB0B0B0);
  static const greenWrasse = Color(0xFF1FD522);
}

class ThemeColors extends ThemeExtension<ThemeColors> {
  factory ThemeColors({
    required final Brightness brightness,
    Color primary = _AppColors.white,
    Color secondary = _AppColors.black,
    Color cardColor = _AppColors.white,
    Color scaffoldBackgroundColor = _AppColors.bleachedSilk,
    Color appBarBackground = _AppColors.bleachedSilk,
    Color bottomNavBarBackground = _AppColors.white,
    Color bottomNavBarSelectedItem = _AppColors.blueDepression,
    Color bottomNavBarUnselectedItem = _AppColors.platinumGranite,
    Color currencyCardSymbolBackground = _AppColors.blueDepression,
    Color bottomNavBarShadow = _AppColors.black25,
  }) =>
      ThemeColors.raw(
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        cardColor: cardColor,
        scaffoldBackground: scaffoldBackgroundColor,
        appBarBackground: appBarBackground,
        appBarSurfaceTint: _AppColors.transparent,
        bottomNavBarBackground: bottomNavBarBackground,
        bottomNavBarSelectedItem: bottomNavBarSelectedItem,
        bottomNavBarUnselectedItem: bottomNavBarUnselectedItem,
        currencyCardSymbolBackground: currencyCardSymbolBackground,
        bottomNavBarShadow: bottomNavBarShadow,
        white: _AppColors.white,
        black: _AppColors.black,
        grey: _AppColors.grey,
        red: _AppColors.red,
        stormyGrey: _AppColors.stormyGrey,
        blueDepression: _AppColors.blueDepression,
        platinumGranite: _AppColors.platinumGranite,
        tin: _AppColors.tin,
        greenWrasse: _AppColors.greenWrasse,
      );

  factory ThemeColors.light() => ThemeColors(brightness: Brightness.light);

  factory ThemeColors.dark() => ThemeColors(
        brightness: Brightness.dark,
        primary: _AppColors.black,
        secondary: _AppColors.white,
        cardColor: _AppColors.dynamicBlack,
        scaffoldBackgroundColor: _AppColors.dartToneInk,
        appBarBackground: _AppColors.dartToneInk,
        bottomNavBarBackground: _AppColors.dynamicBlack,
        bottomNavBarSelectedItem: _AppColors.bluePartyParrot,
        bottomNavBarUnselectedItem: _AppColors.palladium,
        currencyCardSymbolBackground: _AppColors.bluePartyParrot,
        bottomNavBarShadow: _AppColors.transparent,
      );

  const ThemeColors.raw({
    required this.brightness,
    required this.primary,
    required this.secondary,
    required this.cardColor,
    required this.scaffoldBackground,
    required this.appBarBackground,
    required this.appBarSurfaceTint,
    required this.bottomNavBarBackground,
    required this.bottomNavBarSelectedItem,
    required this.bottomNavBarUnselectedItem,
    required this.currencyCardSymbolBackground,
    required this.bottomNavBarShadow,
    required this.white,
    required this.black,
    required this.grey,
    required this.red,
    required this.stormyGrey,
    required this.blueDepression,
    required this.platinumGranite,
    required this.tin,
    required this.greenWrasse,
  });

  final Brightness brightness;
  final Color primary;
  final Color secondary;
  final Color cardColor;
  final Color scaffoldBackground;
  final Color appBarBackground;
  final Color appBarSurfaceTint;
  final Color bottomNavBarBackground;
  final Color bottomNavBarSelectedItem;
  final Color bottomNavBarUnselectedItem;
  final Color currencyCardSymbolBackground;
  final Color bottomNavBarShadow;
  final Color white;
  final Color black;
  final Color grey;
  final Color red;
  final Color stormyGrey;
  final Color blueDepression;
  final Color platinumGranite;
  final Color tin;
  final Color greenWrasse;

  @override
  ThemeColors copyWith({
    Brightness? brightness,
    Color? primary,
    Color? secondary,
    Color? cardColor,
    Color? scaffoldBackground,
    Color? appBarBackground,
    Color? appBarSurfaceTint,
    Color? bottomNavBarBackground,
    Color? bottomNavBarSelectedItem,
    Color? bottomNavBarUnselectedItem,
    Color? currencyCardSymbolBackground,
    Color? bottomNavBarShadow,
    Color? white,
    Color? black,
    Color? grey,
    Color? red,
    Color? stormyGrey,
    Color? blueDepression,
    Color? bleachedSilk,
    Color? platinumGranite,
    Color? tin,
    Color? dynamicBlack,
    Color? bluePartyParrot,
    Color? dartToneInk,
    Color? palladium,
    Color? greenWrasse,
  }) {
    return ThemeColors.raw(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      cardColor: cardColor ?? this.cardColor,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarSurfaceTint: appBarSurfaceTint ?? this.appBarSurfaceTint,
      bottomNavBarBackground: bottomNavBarBackground ?? this.bottomNavBarBackground,
      bottomNavBarSelectedItem: bottomNavBarSelectedItem ?? this.bottomNavBarSelectedItem,
      bottomNavBarUnselectedItem: bottomNavBarUnselectedItem ?? this.bottomNavBarUnselectedItem,
      currencyCardSymbolBackground: currencyCardSymbolBackground ?? this.currencyCardSymbolBackground,
      bottomNavBarShadow: bottomNavBarShadow ?? this.bottomNavBarShadow,
      white: white ?? this.white,
      black: black ?? this.black,
      grey: grey ?? this.grey,
      red: red ?? this.red,
      stormyGrey: stormyGrey ?? this.stormyGrey,
      blueDepression: blueDepression ?? this.blueDepression,
      platinumGranite: platinumGranite ?? this.platinumGranite,
      tin: tin ?? this.tin,
      greenWrasse: greenWrasse ?? this.greenWrasse,
    );
  }

  @override
  ThemeColors lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) return this;

    return copyWith(
      primary: Color.lerp(primary, other.primary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      cardColor: Color.lerp(cardColor, other.cardColor, t),
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t),
      appBarBackground: Color.lerp(appBarBackground, other.appBarBackground, t),
      appBarSurfaceTint: Color.lerp(appBarSurfaceTint, other.appBarSurfaceTint, t),
      bottomNavBarBackground: Color.lerp(bottomNavBarBackground, other.bottomNavBarBackground, t),
      bottomNavBarSelectedItem: Color.lerp(bottomNavBarSelectedItem, other.bottomNavBarSelectedItem, t),
      bottomNavBarUnselectedItem: Color.lerp(bottomNavBarUnselectedItem, other.bottomNavBarUnselectedItem, t),
      currencyCardSymbolBackground: Color.lerp(currencyCardSymbolBackground, other.currencyCardSymbolBackground, t),
      bottomNavBarShadow: Color.lerp(bottomNavBarShadow, other.bottomNavBarShadow, t),
      white: Color.lerp(white, other.white, t),
      black: Color.lerp(black, other.black, t),
      grey: Color.lerp(grey, other.grey, t),
      red: Color.lerp(red, other.red, t),
      stormyGrey: Color.lerp(stormyGrey, other.stormyGrey, t),
      blueDepression: Color.lerp(blueDepression, other.blueDepression, t),
      platinumGranite: Color.lerp(platinumGranite, other.platinumGranite, t),
      tin: Color.lerp(tin, other.tin, t),
      greenWrasse: Color.lerp(greenWrasse, other.greenWrasse, t),
    );
  }
}
