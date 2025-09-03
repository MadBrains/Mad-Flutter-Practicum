part of 'theme_data.dart';

class ThemeFonts extends ThemeExtension<ThemeFonts> {
  factory ThemeFonts({String? fontFamily = 'Inter', Color? color}) {
    late final TextStyle defaultStyle = TextStyle(fontFamily: fontFamily, color: color, fontWeight: FontWeight.normal);

    return ThemeFonts.raw(
      regular12: defaultStyle.copyWith(fontSize: 12),
      regular14: defaultStyle.copyWith(fontSize: 14),
      regular16: defaultStyle.copyWith(fontSize: 16),
      semiBold12: defaultStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
    );
  }

  const ThemeFonts.raw({
    required this.regular12,
    required this.regular14,
    required this.regular16,
    required this.semiBold12,
  });

  final TextStyle regular12;
  final TextStyle regular14;
  final TextStyle regular16;
  final TextStyle semiBold12;

  @override
  ThemeFonts copyWith({
    final TextStyle? regular12,
    final TextStyle? regular14,
    final TextStyle? regular16,
    final TextStyle? semiBold12,
  }) {
    return ThemeFonts.raw(
      regular12: regular12 ?? this.regular12,
      regular14: regular14 ?? this.regular14,
      regular16: regular16 ?? this.regular16,
      semiBold12: semiBold12 ?? this.semiBold12,
    );
  }

  @override
  ThemeFonts lerp(ThemeExtension<ThemeFonts>? other, double t) {
    if (other is! ThemeFonts) {
      return this;
    }

    return copyWith(
      regular12: TextStyle.lerp(regular12, other.regular12, t),
      regular14: TextStyle.lerp(regular14, other.regular14, t),
      regular16: TextStyle.lerp(regular16, other.regular16, t),
      semiBold12: TextStyle.lerp(semiBold12, other.semiBold12, t),
    );
  }
}
