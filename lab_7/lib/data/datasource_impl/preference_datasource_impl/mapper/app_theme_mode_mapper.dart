import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/model/app_theme_mode_dao.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

extension AppThemeModeDaoMapper on AppThemeModeDao {
  AppThemeMode get model => switch (this) {
        AppThemeModeDao.light => AppThemeMode.light,
        AppThemeModeDao.dark => AppThemeMode.dark,
        AppThemeModeDao.system => AppThemeMode.system,
      };
}
