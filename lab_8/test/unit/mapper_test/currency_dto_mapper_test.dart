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
