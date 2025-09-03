import 'dart:async';

import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._datasource);

  final PreferenceDatasource _datasource;

  final StreamController<bool> _authStatusController = StreamController.broadcast();
  final StreamController<AppThemeMode> _themeModeController = StreamController.broadcast();

  late bool _isAuth;

  @override
  Future<void> initAsyncData() async {
    final bool isAuth = await getToken() != null;
    _authStatusController.add(isAuth);
    _isAuth = isAuth;
  }

  @override
  Stream<bool> get isAuthStream => _authStatusController.stream;

  @override
  bool get isAuth => _isAuth;

  @override
  Stream<AppThemeMode> get themeModeStream => _themeModeController.stream;

  @override
  AppThemeMode get themeMode => _datasource.themeMode;

  @override
  void setThemeMode(AppThemeMode mode) {
    _datasource.setThemeMode(mode);

    _themeModeController.add(mode);
  }

  @override
  Future<String?> getToken() => _datasource.getToken();

  @override
  Future<void> setToken(String? token) async {
    await _datasource.setToken(token);

    _authStatusController.add(token != null);
  }
}
