import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/constants.dart';
import 'package:mad_flutter_practicum/app/home.dart';
import 'package:mad_flutter_practicum/app/login_page.dart';
import 'package:mad_flutter_practicum/app/splash_page.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';
import 'package:mad_flutter_practicum/app/utils/theme_mode_ext.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/preference_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasorce_impl/sqflite_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/currency_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/news_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/settings_repository_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(AppConstants.ruLocale, null);

  final sharedPreferences = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  final restDatasource = RestDatasourceImpl();
  final dbDatasource = SqfliteDatasourceImpl();
  final preferenceDatasource = PreferenceDatasourceImpl(sharedPreferences, secureStorage);

  runApp(
    GlobalProviders(
      restDatasource: restDatasource,
      dbDatasource: dbDatasource,
      preferenceDatasource: preferenceDatasource,
      child: const App(),
    ),
  );
}

class GlobalProviders extends StatelessWidget {
  const GlobalProviders({
    super.key,
    required this.restDatasource,
    required this.dbDatasource,
    required this.preferenceDatasource,
    required this.child,
  });

  final RestDatasource restDatasource;
  final DbDatasource dbDatasource;
  final PreferenceDatasource preferenceDatasource;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CurrencyRepository>(
          create: (_) => CurrencyRepositoryImpl(
            restDatasource,
            dbDatasource,
          ),
        ),
        Provider<NewsRepository>(
          create: (_) => NewsRepositoryImpl(
            restDatasource,
            dbDatasource,
          ),
        ),
        Provider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(preferenceDatasource),
        ),
      ],
      child: child,
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  Future<void> _initData() async {
    await Future.delayed(Duration(seconds: 1));

    await _settingsRepository.initAsyncData();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _settingsRepository.themeModeStream,
      builder: (BuildContext context, AsyncSnapshot<AppThemeMode> snapshot) {
        final AppThemeMode appThemeMode = snapshot.data ?? _settingsRepository.themeMode;

        return MaterialApp(
          theme: ThemeData.light().appThemeData,
          darkTheme: ThemeData.dark().appThemeData,
          themeMode: appThemeMode.themeMode,
          home: StreamBuilder(
            stream: _settingsRepository.isAuthStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const SplashPage();

              final bool isAuth = snapshot.data ?? _settingsRepository.isAuth;

              return isAuth ? const HomePage() : const LoginPage();
            },
          ),
        );
      },
    );
  }
}
