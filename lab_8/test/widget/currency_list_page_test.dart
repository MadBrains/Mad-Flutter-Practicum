import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
import 'package:mockito/mockito.dart';

import '../mocks/repository.mocks.dart';

import 'widget.dart';

Future<void> main() async {
  await initializeDateFormatting(AppConstants.ruLocale, null);

  group('CurrencyListPage', () {
    final MockCurrencyRepository mockCurrencyRepository = MockCurrencyRepository();

    final currencyItems = [
      CurrencyModel(
        id: '1',
        nominal: 1,
        name: 'Доллар США',
        symbol: 'USD',
        value: 78.4181,
        previousValue: 78.5,
      ),
      CurrencyModel(
        id: '2',
        nominal: 1,
        name: 'Евро',
        symbol: 'EUR',
        value: 92.7440,
        previousValue: 92.2,
      ),
    ];

    setUp(() {
      when(mockCurrencyRepository.getCurrencyList()).thenAnswer((_) async => currencyItems);
      when(mockCurrencyRepository.saveCurrencyList(any)).thenAnswer((_) async {});
    });

    testWidgets('should display all currency items when loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          providers: [
            Provider<CurrencyRepository>.value(value: mockCurrencyRepository),
          ],
          child: CurrencyListPage(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('USD'), findsOneWidget);
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('JPY'), findsNothing);
      expect(find.byType(CurrencyCard), findsNWidgets(currencyItems.length));
    });

    testWidgets('should navigate to detail page when currency card is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          providers: [
            Provider<CurrencyRepository>.value(value: mockCurrencyRepository),
          ],
          child: const CurrencyListPage(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(CurrencyCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(CurrencyDetailPage), findsOneWidget);
    });

    testWidgets('should filter currencies when search text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          providers: [
            Provider<CurrencyRepository>.value(value: mockCurrencyRepository),
          ],
          child: const CurrencyListPage(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Евро');
      await tester.pump();

      expect(find.byType(CurrencyCard), findsOneWidget);
    });
  });
}
