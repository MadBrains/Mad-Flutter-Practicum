import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
import 'package:mockito/mockito.dart';

import '../mocks/repository.mocks.dart';

import 'widget.dart';

Future<void> main() async {
  await initializeDateFormatting(AppConstants.ruLocale, null);

  group('NewsListPage', () {
    final MockNewsRepository mockNewsRepository = MockNewsRepository();

    final newsItems = [
      NewsModel(title: 'Заголовок 1', link: 'https://example.com/1', date: DateTime.now()),
      NewsModel(title: 'Заголовок 2', link: 'https://example.com/2', date: DateTime.now()),
    ];

    setUp(() {
      when(mockNewsRepository.getNewsList()).thenAnswer((_) async => newsItems);
      when(mockNewsRepository.saveNewsList(any)).thenAnswer((_) async {});
    });

    testWidgets('should display all news items when loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          providers: [
            Provider<NewsRepository>.value(value: mockNewsRepository),
          ],
          child: const NewsListPage(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Заголовок 1'), findsOneWidget);
      expect(find.text('Заголовок 2'), findsOneWidget);
      expect(find.text('Заголовок 3'), findsNothing);
    });
  });
}
