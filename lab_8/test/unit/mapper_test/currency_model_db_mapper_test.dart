import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasource_impl/mapper/currency_model_mapper.dart';
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
