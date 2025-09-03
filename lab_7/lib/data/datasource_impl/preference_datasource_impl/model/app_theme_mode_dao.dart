enum AppThemeModeDao {
  light,
  dark,
  system;

  static AppThemeModeDao fromString(String? name) =>
      AppThemeModeDao.values.firstWhere((e) => e.name == name, orElse: () => AppThemeModeDao.system);
}
