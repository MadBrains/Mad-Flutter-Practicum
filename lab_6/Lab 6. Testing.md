# Лабораторная работа №6. Тестирование приложения

## 1. Цель работы

Целью настоящей лабораторной работы является освоение подходов к тестированию компонентов Flutter-приложения. В процессе выполнения работы студенты получают практические навыки:

- написания модульных тестов для репозиториев и бизнес-логики;
- использования библиотеки `mockito` для изоляции зависимостей и подмены реальных источников данных;
- проверки корректности вызовов методов и возвращаемых значений;
- конфигурации среды и запуска тестов с использованием `test`, `flutter_test` и `integration_test`.

В качестве объекта тестирования выступают классы, реализующие логику получения и сохранения данных (например, `CurrencyRepositoryImpl`). Результатом выполнения лабораторной работы является набор автоматизированных тестов, обеспечивающих верификацию ключевых сценариев взаимодействия между слоями приложения.

## 2. Общее описание

Во Flutter-проектах тестирование — это не просто проверка корректности работы компонентов, но и важный инструмент поддержки качества кода на всех этапах жизненного цикла приложения. Лабораторная работа направлена на практическое освоение различных уровней тестирования, включая модульные и интеграционные тесты, с упором на изоляцию бизнес-логики от внешних зависимостей.

Особое внимание уделяется применению библиотеки `mockito`, которая позволяет создавать замещающие реализации интерфейсов для тестирования в изоляции. Студенты научатся не только имитировать поведение внешних источников данных, но и проверять вызовы, аргументы и возвращаемые значения с использованием моков.

Также в работе рассматриваются подходы к структурированию тестов по слоям архитектуры, запуску тестов в разных средах (`flutter_test`, `test`, `integration_test`) и интерпретации результатов. Предлагаемые практики соответствуют рекомендациям по построению устойчивых и легко сопровождаемых проектов на Flutter.

В результате выполнения работы студенты смогут уверенно применять тестирование при разработке, обеспечивая надёжность ключевых компонентов без необходимости ручной проверки после каждого изменения.

## 3. Основная часть

### Объявление зависимостей

Для организации модульного тестирования необходимо подключить в проект следующие зависимости. Откройте файл `pubspec.yaml` и добавьте или убедитесь, что присутствуют следующие записи в разделе `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  integration_test:
    sdk: flutter

  test: 1.25.15
  mockito: 5.4.6

  build_runner: 2.4.15
```

- `test` — нативная библиотека Dart для юнит-тестирования. Используется преимущественно для тестов, не зависящих от Flutter SDK (например, утилитарных классов, функций, парсеров и др.).
- `flutter_test` — встроенная библиотека для написания юнит- и виджет-тестов во Flutter. Используется по умолчанию в большинстве проектов.
- `integration_test` — официальный пакет для написания сквозных (end-to-end) тестов, моделирующих поведение реального пользователя.
- `mockito` — инструмент для генерации подменных реализаций (mock-объектов) интерфейсов и абстракций. Необходим для изоляции тестируемого класса от его зависимостей.
- `build_runner` — служебный инструмент, обеспечивающий генерацию mock-классов на основе аннотаций `@GenerateMocks`.

> ⚠️ Обратите внимание: хотя `flutter_test` и `test` имеют схожую функциональность, они используются в разных контекстах.
Библиотека `test` не требует Flutter-окружения и может применяться для тестирования чистого Dart-кода, что особенно актуально для утилит и вспомогательных слоёв проекта.

### Организация структуры тестов

Для обеспечения читаемости и расширяемости тестовой инфраструктуры проекта рекомендуется придерживаться чёткой структуры каталогов. Тесты разделяются по типам и назначению:

#### Каталог `test/`

Используется для размещения:

- **модульных (юнит) тестов**: проверяют работу отдельных классов (например, репозиториев, мапперов, утилит);
- **виджет-тестов**: охватывают поведение UI-компонентов в изоляции;
- **вспомогательных файлов**: mock-реализаций, фикстур, заготовленных моделей.

#### Каталог `integration_test/`

Предназначен для размещения **интеграционных (end-to-end) тестов**, моделирующих реальные сценарии взаимодействия пользователя с приложением.

> ⚠️ Интеграционные тесты работают с полноценным экземпляром приложения (подобно тому, что вы запускали с помощью `runApp(...)`) и позволяют проверять поведение на уровне пользовательских сценариев, переходов между экранами, работы навигации и платформенных взаимодействий. Это обеспечивается через вызов `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`, который подключает реальный движок Flutter к среде исполнения на устройстве или эмуляторе, в отличие от виджет-тестов, выполняющихся в изолированной среде.

#### Рекомендации по организации

- Названия тестовых файлов должны соответствовать именам тестируемых классов с постфиксом `_test.dart`;
- Файл должен содержать группу `group()` (например, если вы хотите их разделить по какому-то принципу) и понятные имена тестов (`test()`);
- Для генерации mock-объектов создаётся отдельный файл в `test/mocks/` с аннотацией `@GenerateMocks` и последующим запуском `build_runner`.

> ✅ Поддержание структуры тестов облегчает масштабирование проекта, параллельную разработку и проведение ревью.

### Создание и использование mock-объектов

Для модульного тестирования классов, имеющих внешние зависимости (например, доступ к REST API или локальной базе данных), важно уметь подменять эти зависимости с целью изоляции тестируемой логики. Для этого используется библиотека `mockito`, позволяющая создавать mock-объекты — поддельные реализации интерфейсов, поведение которых можно контролировать вручную.

#### Шаг 1. Создание файла с аннотацией

Создайте файл `test/mocks/repository.dart`, содержащий аннотацию `@GenerateMocks` с перечнем интерфейсов, которые необходимо замокировать:

```dart
import 'package:mockito/annotations.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

@GenerateMocks([CurrencyRepository, NewsRepository, SettingsRepository])
void main() {}
```

Аналогично для `test/mocks/datasource.dart`:

```dart
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([RestDatasource, DbDatasource, PreferenceDatasource])
void main() {}
```

#### Шаг 2. Генерация mock-классов
Для генерации mock-реализаций необходимо выполнить команду:

```bash
dart run build_runner build
```

В результате в той же директории будут созданы файлы `repository.mocks.dart` и `datasource.mocks.dart`, содержащие автоматически сгенерированные классы, указанные в аннотации с припиской `Mock`.

#### Шаг 3. Использование mock-объектов в тестах
Mock-объекты можно использовать в тестах как замену реальным зависимостям поскольку они наследуют указанные классы:

```dart
// Репозитории
final CurrencyRepository mockCurrencyRepository = MockCurrencyRepository();
final NewsRepository mockNewsRepository = MockNewsRepository();
final SettingsRepository mockSettingsRepository = MockSettingsRepository();

// Источники данных
final MockRestDatasource mockRestDatasource = MockRestDatasource();
final MockDbDatasource mockDbDatasource = MockDbDatasource();
final MockPreferenceDatasource mockPreferenceDatasource = MockPreferenceDatasource();
```

### Юнит-тесты (Unit Tests)

В каталоге `test/unit/` организованы модульные тесты, сгруппированные по назначению. Это позволяет логически разделить проверку бизнес-логики (репозиториев) и вспомогательных компонентов (мапперов) и обеспечивает читаемость и масштабируемость структуры проекта.

#### Тесты мапперов (`mapper_test/`)

В директории `test/unit/mapper_test/` размещены тесты, проверяющие корректность преобразования моделей (DTO, Entity) и типов. Мапперы — это ключевые вспомогательные классы, обеспечивающие связь между слоями `data` и `domain`.

Созданы следующие файлы:

- `app_theme_mode_mapper_test.dart` — тестирование конвертации между `String` и перечислением `AppThemeMode`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/mapper/app_theme_mode_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/model/app_theme_mode_dao.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

void main() {
  void run(String? input, AppThemeMode expectedMode) {
    test('AppThemeModeDao.fromString("$input") should map to $expectedMode', () {
      final AppThemeModeDao mode = AppThemeModeDao.fromString(input);

      final result = mode.model;

      expect(result, expectedMode);
    });
  }

  group('AppThemeModeDao.fromString mapping tests', () {
    for (final mode in AppThemeMode.values) {
      run(mode.name, mode);
    }

    run(null, AppThemeMode.system);
  });
}
```

- `currency_dto_mapper_test.dart` — проверка маппинга данных из DTO-модели валюты

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/currency_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/model/currency_dto.dart';

void main() {
  group('CurrencyDto to CurrencyModel mapping', () {
    test('should correctly map all fields when valid JSON is provided', () {
      final json = {
        "ID": "R01235",
        "Nominal": 1,
        "Name": "Доллар США",
        "CharCode": "USD",
        "Value": 90.5,
        "Previous": 89.1
      };

      final dto = CurrencyDto.fromJson(json);

      final model = dto.model;

      expect(model.id, 'R01235');
      expect(model.nominal, 1);
      expect(model.name, 'Доллар США');
      expect(model.symbol, 'USD');
      expect(model.value, 90.5);
      expect(model.previousValue, 89.1);
    });

    test('should set default values when JSON is empty', () {
      final json = <String, dynamic>{};

      final dto = CurrencyDto.fromJson(json);
      final model = dto.model;

      expect(model.id, '');
      expect(model.nominal, 0);
      expect(model.name, '');
      expect(model.symbol, '');
      expect(model.value, 0);
      expect(model.previousValue, 0);
    });
  });
}
```

- `currency_model_db_mapper_test.dart` — проверка преобразования валютной модели в структуру для базы данных и обратно

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasorce_impl/mapper/currency_model_mapper.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

void main() {
  group('CurrencyModelDbMapper conversions', () {
    const testModel = CurrencyModel(
      id: 'USD',
      name: 'Доллар США',
      symbol: 'USD',
      value: 90.5,
      nominal: 1,
      previousValue: 89.1,
    );

    final testMap = {
      'id': 'USD',
      'name': 'Доллар США',
      'symbol': 'USD',
      'value': 90.5,
      'nominal': 1,
      'previousValue': 89.1,
    };

    test('correctly converts model to map', () {
      final map = testModel.toMap();

      expect(map, testMap);
    });

    test('correctly converts map to model', () {
      final model = CurrencyModelDbMapper.fromMap(testMap);

      expect(model.id, testModel.id);
      expect(model.name, testModel.name);
      expect(model.symbol, testModel.symbol);
      expect(model.value, testModel.value);
      expect(model.nominal, testModel.nominal);
      expect(model.previousValue, testModel.previousValue);
    });

    test('toMap and fromMap are inverses', () {
      final map = testModel.toMap();
      final restoredModel = CurrencyModelDbMapper.fromMap(map);

      expect(restoredModel, isA<CurrencyModel>());
      expect(restoredModel.id, testModel.id);
      expect(restoredModel.name, testModel.name);
      expect(restoredModel.symbol, testModel.symbol);
      expect(restoredModel.value, testModel.value);
      expect(restoredModel.nominal, testModel.nominal);
      expect(restoredModel.previousValue, testModel.previousValue);
    });
  });
}
```

- `news_item_mapper_test.dart` — тестирование преобразования элементов RSS-ленты в модель новости

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/constants.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/news_mapper.dart';
import 'package:rss_dart/domain/rss_item.dart';
import 'package:intl/intl.dart';

void main() {
  group('RssItem to NewsModel mapping', () {
    test('maps valid RssItem with complete data correctly', () {
      final rssItem = RssItem(
        title: 'Test title',
        link: 'https://example.com/news',
        pubDate: 'Fri, 21 Jun 2024 12:00:00 +0300',
      );

      final model = rssItem.asNewsModel;

      expect(model.title, 'Test title');
      expect(model.link, 'https://example.com/news');
      expect(
        model.date,
        DateFormat(RestConstants.newsDateTimeFormat).parse('Fri, 21 Jun 2024 12:00:00 +0300'),
      );
    });

    test('handles null fields with default values', () {
      final rssItem = RssItem(
        title: null,
        link: null,
        pubDate: null,
      );

      final model = rssItem.asNewsModel;

      expect(model.title, '');
      expect(model.link, '');
      expect(model.date, isNull);
    });
  });
}
```

#### Тесты репозиториев

В файле `test/unit/repository_test.dart` размещаются модульные тесты репозиториев. Эти классы реализуют бизнес-логику и взаимодействие с источниками данных (сетевыми или локальными). Для изоляции используются mock-объекты зависимостей.

- `currency_repository_test.dart` — тестирование методов получения и сохранения валют

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/repository_impl/currency_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/news_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/settings_repository_impl.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

import '../mocks/datasource.mocks.dart';

void main() {
  final MockRestDatasource mockRestDatasource = MockRestDatasource();
  final MockDbDatasource mockDbDatasource = MockDbDatasource();
  final MockPreferenceDatasource mockPreferenceDatasource = MockPreferenceDatasource();

  group('CurrencyRepository', () {
    late CurrencyRepository repository;

    setUp(() {
      repository = CurrencyRepositoryImpl(mockRestDatasource, mockDbDatasource);
    });

    test('should return correct currency list when getCurrencyList is called', () async {
      final currencyList = [
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

      when(mockRestDatasource.getCurrencyList()).thenAnswer((_) async => currencyList);

      final result = await repository.getCurrencyList();

      expect(result, currencyList);
      verify(mockRestDatasource.getCurrencyList()).called(1);
    });

    test('should complete successfully when saveCurrencyList is called', () async {
      final currencyList = [
        CurrencyModel(
          id: '1',
          nominal: 1,
          name: 'Юань',
          symbol: 'CNY',
          value: 10.9384,
          previousValue: 10.9112,
        ),
      ];

      await repository.saveCurrencyList(currencyList);

      verify(mockDbDatasource.saveCurrencyList(currencyList)).called(1);
    });
  });

  group('NewsRepository', () {
    late NewsRepository repository;

    setUp(() {
      repository = NewsRepositoryImpl(mockRestDatasource, mockDbDatasource);
    });

    test('should return news list when getNewsList is called', () async {
      final newsList = [
        for (int i = 0; i < 3; i++)
          NewsModel(title: 'Заголовок $i', link: 'https://example.com/$i', date: DateTime.now()),
      ];

      when(mockRestDatasource.getNewsList()).thenAnswer((_) async => newsList);

      final result = await repository.getNewsList();

      expect(result, newsList);
      verify(mockRestDatasource.getNewsList()).called(1);
    });

    test('should complete successfully when saveNewsList is called', () async {
      final newsList = [
        NewsModel(title: 'Заголовок 1', link: 'https://example.com/1', date: DateTime.now()),
      ];

      await repository.saveNewsList(newsList);

      verify(mockDbDatasource.saveNewsList(newsList)).called(1);
    });
  });

  group('SettingsRepository', () {
    late SettingsRepository settingsRepository;

    setUp(() {
      settingsRepository = SettingsRepositoryImpl(mockPreferenceDatasource);
    });

    test('should complete initialization without errors', () async {
      when(mockPreferenceDatasource.getToken()).thenAnswer((_) => Future.value('my-token'));

      await settingsRepository.initAsyncData();

      verify(settingsRepository.initAsyncData()).called(1);
    });

    test('should return correct token when getToken is called', () async {
      when(mockPreferenceDatasource.getToken()).thenAnswer((_) => Future.value('my-token'));

      final token = await settingsRepository.getToken();

      expect(token, 'my-token');
      verify(settingsRepository.getToken()).called(1);
    });

    test('should complete token setting successfully', () async {
      await settingsRepository.setToken('abc');

      verify(mockPreferenceDatasource.setToken('abc')).called(1);
    });

    test('should set theme mode with correct value', () {
      settingsRepository.setThemeMode(AppThemeMode.dark);

      verify(mockPreferenceDatasource.setThemeMode(AppThemeMode.dark)).called(1);
    });

    test('should return current theme mode value', () {
      when(mockPreferenceDatasource.themeMode).thenReturn(AppThemeMode.light);

      final result = settingsRepository.themeMode;

      expect(result, AppThemeMode.light);
      verify(mockPreferenceDatasource.themeMode).called(1);
    });

    test('should emit theme mode changes through stream', () async {
      final stream = Stream<AppThemeMode>.fromIterable([
        AppThemeMode.system,
        AppThemeMode.dark,
      ]);

      expectLater(
        settingsRepository.themeModeStream,
        emitsInOrder([AppThemeMode.system, AppThemeMode.dark]),
      );

      await for (final mode in stream) {
        settingsRepository.setThemeMode(mode);
      }
    });

    test('should emit auth state changes through stream', () async {
      final stream = Stream<String?>.fromIterable(['token', null]);

      expectLater(
        settingsRepository.isAuthStream,
        emitsInOrder([true, false]),
      );

      await for (final token in stream) {
        settingsRepository.setToken(token);
      }
    });
  });
}
```

> ✅ При написании модульных тестов мапперов и репозиториев важно не только проверять возвращаемые значения, но и верифицировать корректность вызовов и передачу аргументов.

### Виджет-тесты (Widget Tests)

Виджет-тесты позволяют проверять корректность отображения и поведения интерфейсных компонентов в изоляции, без запуска полноценного приложения. Они используют библиотеку `flutter_test` и выполняются в специальной headless-среде.

В проекте все виджет-тесты сгруппированы в каталоге `test/widget/`. Каждый тестовый файл посвящён отдельному экрану или контейнеру интерфейса. Ниже приведён краткий обзор файлов:

- `widget.dart` - вспомогательный файл для виджет-тестов. Содержит функцию `buildWidget`, которая оборачивает переданный виджет в `MaterialApp` и `MultiProvider` (если указаны провайдеры). Используется для удобного запуска виджетов в тестах с нужным окружением.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildWidget({
  List<Provider> providers = const [],
  required Widget child,
}) =>
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: child,
      ),
    );
```

- `currency_list_page_test.dart` — проверка отображения списка валют, взаимодействия с `FutureBuilder`, наличия индикатора загрузки и элементов списка

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/constants.dart';
import 'package:mad_flutter_practicum/app/currency_detail/currency_detail_page.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

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
```

- `news_list_page_test.dart` — проверка построения списка новостей, правильного отображения карточек и состояния в зависимости от наличия данных

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/constants.dart';
import 'package:mad_flutter_practicum/app/news_list/news_list_page.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

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
```

- `login_page_test.dart` — тестирование интерфейса авторизации, в том числе наличия кнопки входа и вызова соответствующего метода репозитория при взаимодействии

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/app/login_page.dart';
import 'package:mad_flutter_practicum/data/repository_impl/settings_repository_impl.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/datasource.mocks.dart';

import 'widget.dart';

void main() {
  final MockPreferenceDatasource mockPreferenceDatasource = MockPreferenceDatasource();

  late SettingsRepository settingsRepository;

  setUp(() {
    settingsRepository = SettingsRepositoryImpl(mockPreferenceDatasource);
  });

  group('LoginPage', () {
    testWidgets('should call setToken when login button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          providers: [
            Provider<SettingsRepository>.value(value: settingsRepository),
          ],
          child: const LoginPage(),
        ),
      );

      final loginButton = find.text('Войти');
      expect(loginButton, findsOneWidget);

      verifyNever(settingsRepository.setToken(any));

      await tester.tap(loginButton);

      verify(settingsRepository.setToken(any)).called(1);
    });
  });
}
```

- `home_container_test.dart` — проверка логики переключения вкладок нижней навигации, а также корректного отображения выбранного экрана

```dart
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
```

> ✅ Важно помнить, что виджет-тесты запускаются в изолированной среде, поэтому любые зависимости (включая репозитории и провайдеры) должны быть подменены вручную через обёртки или mock-объекты.

### Интеграционные тесты (Integration Tests)

Интеграционные тесты моделируют поведение пользователя в реальном приложении и позволяют проверить работу навигации, переходов между экранами, состояния и реакцию на пользовательские действия вживую. Такие тесты запускаются не в тестовой среде, а на настоящем устройстве или эмуляторе, и, в отличие от unit и widget-тестов, работают с полным экземпляром приложения.

#### Структура и размещение

Интеграционные тесты размещаются в отдельной директории `integration_test/`, расположенной на одном уровне с папкой `test/`. Это сделано намеренно поскольку:

- каталог `test/` предназначен для тестов, выполняемых в среде `flutter test`;
- каталог `integration_test/` используется для тестов, запускаемых через `flutter test integration_test` или `flutter drive`, и требует полноценного окружения.

> 📌 Таким образом, Flutter чётко разделяет два режима выполнения: изолированные (`flutter test`) и полнофункциональные (`flutter test integration_test`).

#### Содержимое директории

- `app_test.dart` — основной файл с тестами пользовательских сценариев. Здесь моделируются действия пользователя, например: запуск приложения, вход, переключение темы, переход по вкладкам и т.д.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/constants.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/login_page.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/preference_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasorce_impl/sqflite_datasource_impl.dart';
import 'package:mad_flutter_practicum/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
```

> ✅ Интеграционные тесты особенно полезны для проверки цепочек экранов, работы с реальными плагинами (SharedPreferences, HTTP, SQLite) и общей стабильности приложения при длительной сессии.

## 4. Самостоятельная часть

> Перед выполнением задания рекомендуется выбрать целевой уровень (оценку), что позволит определить глубину проработки и трудоёмкость реализации. Все уровни ориентированы на закрепление и расширение знаний в области тестирования Flutter-приложений.

### Задание на оценку "3"

- Реализовать все тестовые сценарии, описанные в основной части лабораторной работы.
- Замените моковые источники данных в unit-тестах на фейковые (fake):
  - `FakeRestDatasource`
  - `FakeDbDatasource`
  - `FakePreferenceDatasource`

> ℹ️ **Фейки (fake)** — это упрощённые, вручную реализованные версии зависимостей, поведение которых контролируется разработчиком. В отличие от mock-объектов, которые автоматически генерируются и используются преимущественно в юнит-тестах, фейки обычно применяются в интеграционных тестах и содержат минимально необходимую логику, имитирующую работу реального компонента. Их преимущество — стабильность и читаемость при работе с полноценным приложением.
За дополнительной информацией можно обратиться к [официальным рекомендациям по написанию фейков](https://pub.dev/packages/mockito#writing-a-fake) в документации `mockito`.

### Задание на оценку "4"

Дополнительно к предыдущим требованиям:

- Реализовать widget-тесты для сценария переключения темы на экране `ProfilePage`.
- Реализовать дополнительный сценарий интеграционного теста, проверяющий переключение темы на экране `ProfilePage`.

> Результат переключения темы нужно сравнивать с `Theme.of(tester.element).brightness`

### Задание на оценку "5"

Дополнительно к предыдущим требованиям:

- Реализовать golden-тесты для ключевых экранов:
  - `SplashPage`
  - `LoginPage`
  - `ProfilePage`
  - `CurrencyListPage`
  - `NewsListPage`
  - `HomePage`

> Для того чтобы подоробнее узнать что такое golden-тесты рекомендую обратиться к материалам ниже.

**Материалы**

1. [Статья Medium `Golden tests in Flutter`](https://medium.com/profusion-engineering/golden-tests-in-flutter-a-comprehensive-guide-b4b50a932fd5) [1]
2. [Обучающее видео от `Mad Brains`](https://www.youtube.com/watch?v=thnLmxQGGRY)
3. [Документация `golden_toolkit`](https://pub.dev/packages/golden_toolkit) [2]
4. [Документация `alchemist`](https://pub.dev/packages/alchemist)

> [1] ⚠️ Платформа `Medium` может быть недоступна на территории РФ без VPN.

> [2] ⚠️ Библиотека `golden_toolkit` в настоящее время признана устаревшей и больше не поддерживается. Вместо неё рекомендуется использовать `alchemist`, как более современную и поддерживаемую альтернативу.