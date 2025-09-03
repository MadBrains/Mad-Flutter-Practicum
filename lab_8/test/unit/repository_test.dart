import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/data.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
import 'package:mockito/mockito.dart';

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
