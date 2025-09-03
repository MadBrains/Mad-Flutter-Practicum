import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';
import 'package:mad_flutter_practicum/app/home.dart';
import 'package:mad_flutter_practicum/app/news_list/news_list_page.dart';
import 'package:mad_flutter_practicum/app/profile/profile_page.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/repository.mocks.dart';
import 'widget.dart';

void main() {
  group('HomePage', () {
    final MockCurrencyRepository mockCurrencyRepository = MockCurrencyRepository();
    final MockNewsRepository mockNewsRepository = MockNewsRepository();
    final MockSettingsRepository mockSettingsRepository = MockSettingsRepository();

    final ImageProvider homeImage = Image.asset('assets/icons/home.png').image;
    final ImageProvider newsImage = Image.asset('assets/icons/news.png').image;
    final IconData profileIcon = Icons.person;

    late Widget homeWidget;

    setUp(() {
      homeWidget = buildWidget(
        providers: [
          Provider<CurrencyRepository>.value(value: mockCurrencyRepository),
          Provider<NewsRepository>.value(value: mockNewsRepository),
          Provider<SettingsRepository>.value(value: mockSettingsRepository),
        ],
        child: const HomePage(),
      );

      when(mockCurrencyRepository.getCurrencyList()).thenAnswer((_) async => []);
      when(mockNewsRepository.getNewsList()).thenAnswer((_) async => []);
      when(mockSettingsRepository.themeMode).thenAnswer((_) => AppThemeMode.system);
    });

    testWidgets('should display all navigation tabs with correct labels and icons', (WidgetTester tester) async {
      await tester.pumpWidget(homeWidget);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(BottomNavigationBar, 'Новости'), findsOneWidget);
      expect(find.widgetWithText(BottomNavigationBar, 'Курс Валют'), findsOneWidget);
      expect(find.widgetWithText(BottomNavigationBar, 'Профиль'), findsOneWidget);

      expect(find.widgetWithImage(BottomNavigationBar, homeImage), findsOneWidget);
      expect(find.widgetWithImage(BottomNavigationBar, newsImage), findsOneWidget);
      expect(find.widgetWithIcon(BottomNavigationBar, profileIcon), findsOneWidget);
    });

    testWidgets('should navigate to correct pages when tabs are tapped', (WidgetTester tester) async {
      await tester.pumpWidget(homeWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.image(homeImage));
      await tester.pumpAndSettle();
      expect(find.byType(CurrencyListPage), findsOneWidget);

      await tester.tap(find.image(newsImage));
      await tester.pumpAndSettle();
      expect(find.byType(NewsListPage), findsOneWidget);

      await tester.tap(find.byIcon(profileIcon));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);
    });
  });
}
