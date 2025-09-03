import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

abstract interface class SettingsRepository {
  Future<void> initAsyncData();

  abstract final Stream<bool> isAuthStream;

  abstract final bool isAuth;

  abstract final Stream<AppThemeMode> themeModeStream;

  abstract final AppThemeMode themeMode;

  void setThemeMode(AppThemeMode mode);

  Future<String?> getToken();

  Future<void> setToken(String? token);
}
