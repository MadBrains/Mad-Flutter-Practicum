import 'package:mad_flutter_practicum/app/app.dart';

final _cachedTheme = AppThemeData.light();

final _cachedLocale = AppLocalizationsRu();

extension ThemeContextExtension on BuildContext {
  AppThemeData get theme => Theme.of(this).extension<AppThemeData>() ?? _cachedTheme;

  ThemeColors get colors => theme.themeColors;

  ThemeFonts get fonts => theme.themeFonts;

  AppLocalizations get loc => AppLocalizations.of(this) ?? _cachedLocale;
}
