import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

extension CurrencyModelDbMapper on CurrencyModel {
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'symbol': symbol,
        'value': value,
        'nominal': nominal,
        'previousValue': previousValue,
      };

  static CurrencyModel fromMap(Map<String, dynamic> map) => CurrencyModel(
        id: map['id'],
        name: map['name'],
        symbol: map['symbol'],
        value: map['value'],
        nominal: map['nominal'],
        previousValue: map['previousValue'],
      );
}
