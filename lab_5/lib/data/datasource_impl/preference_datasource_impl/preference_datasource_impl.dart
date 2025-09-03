import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/mapper/app_theme_mode_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/model/app_theme_mode_dao.dart';
import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class _Keys {
  static const String theme = 'theme_key';
  static const String token = 'token_key';
}

class PreferenceDatasourceImpl implements PreferenceDatasource {
  const PreferenceDatasourceImpl(this._sharedPreferences, this._secureStorage);

  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  @override
  AppThemeMode get themeMode {
    final String? theme = _sharedPreferences.getString(_Keys.theme);

    return AppThemeModeDao.fromString(theme).model;
  }

  @override
  void setThemeMode(AppThemeMode mode) => _sharedPreferences.setString(_Keys.theme, mode.name);

  @override
  Future<String?> getToken() => _secureStorage.read(key: _Keys.theme);

  @override
  Future<void> setToken(String? token) => _secureStorage.write(key: _Keys.token, value: token);
}
