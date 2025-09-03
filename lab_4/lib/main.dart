import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/constants.dart';
import 'package:mad_flutter_practicum/app/home.dart';
import 'package:mad_flutter_practicum/app/splash_page.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/currency_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/news_repository_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await initializeDateFormatting(AppConstants.ruLocale, null);

  final restDatasource = RestDatasourceImpl();

  runApp(
    GlobalProviders(
      restDatasource: restDatasource,
      child: const App(),
    ),
  );
}

class GlobalProviders extends StatelessWidget {
  const GlobalProviders({super.key, required this.restDatasource, required this.child});

  final RestDatasource restDatasource;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CurrencyRepository>(create: (_) => CurrencyRepositoryImpl(restDatasource)),
        Provider<NewsRepository>(create: (_) => NewsRepositoryImpl(restDatasource)),
      ],
      child: child,
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  Future<void> _initApp() async {
    // Имитируем задержку инициализации
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3929C7);
    const backgroundColor = Color(0xFFf2f2f2);
    const secondaryColor = Color(0xFF7F7F7F);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: primaryColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: secondaryColor,
          ),
        ),
      ),
      home: FutureBuilder<void>(
        future: _initApp(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          }
          return const SplashPage();
        },
      ),
    );
  }
}
