import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/data/data.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          locale: Locale('ru', 'RU'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
