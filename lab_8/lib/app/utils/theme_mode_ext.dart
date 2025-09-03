import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

extension NullableAppThemeModeExt on AppThemeMode? {
  ThemeMode get themeMode => switch (this) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        (_) => ThemeMode.system,
      };
}

extension AppThemeModeExt on AppThemeMode {
  String titleOf(AppLocalizations loc) => switch (this) {
        AppThemeMode.light => loc.light,
        AppThemeMode.dark => loc.dark,
        AppThemeMode.system => loc.system,
      };
}
