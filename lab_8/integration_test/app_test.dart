import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';
import 'package:mad_flutter_practicum/data/data.dart';
import 'package:mad_flutter_practicum/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(AppConstants.ruLocale, null);

  final sharedPreferences = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  final restDatasource = RestDatasourceImpl();
  final dbDatasource = SqfliteDatasourceImpl();
  final preferenceDatasource = PreferenceDatasourceImpl(sharedPreferences, secureStorage);

  const Duration commonDuration = Duration(seconds: 1);
  const Duration longDuration = Duration(seconds: 3);

  Future<void> login(WidgetTester tester) async {
    final loginButton = find.widgetWithText(ElevatedButton, 'Войти');
    await tester.tap(loginButton);
    await tester.pumpAndSettle(longDuration);
  }

  Future<void> checkHomeContainer(WidgetTester tester) async {
    expect(find.widgetWithText(BottomNavigationBar, 'Новости'), findsOneWidget);
    expect(find.widgetWithText(BottomNavigationBar, 'Курс Валют'), findsOneWidget);
    expect(find.widgetWithText(BottomNavigationBar, 'Профиль'), findsOneWidget);
  }

  Future<void> checkCurrencyListPage(WidgetTester tester) async {
    await tester.tap(find.byType(CurrencyCard).first);
    await tester.pumpAndSettle(commonDuration);
    await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
    await tester.pumpAndSettle(commonDuration);
  }

  Future<void> checkNewsListPage(WidgetTester tester) async {
    await tester.tap(find.image(Image.asset('assets/icons/news.png').image));
    await tester.pumpAndSettle(longDuration);

    expect(find.byType(NewsCard), findsWidgets);
  }

  Future<void> checkProfilePage(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle(commonDuration);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Выйти'));
    await tester.pumpAndSettle(commonDuration);
  }

  testWidgets('should complete full user flow successfully', (tester) async {
    await tester.pumpWidget(
      GlobalProviders(
        restDatasource: restDatasource,
        dbDatasource: dbDatasource,
        preferenceDatasource: preferenceDatasource,
        child: const App(),
      ),
    );

    await tester.pumpAndSettle(longDuration);

    await login(tester);
    await checkHomeContainer(tester);
    await checkCurrencyListPage(tester);
    await checkNewsListPage(tester);
    await checkProfilePage(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
