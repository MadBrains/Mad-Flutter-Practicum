import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/model/currency_dto.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

extension CurrencyDtoMapper on CurrencyDto {
  CurrencyModel get model => CurrencyModel(
        id: id,
        nominal: nominal,
        name: name,
        symbol: symbol,
        value: value,
        previousValue: previousValue,
      );
}
