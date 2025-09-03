import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

abstract interface class CurrencyRepository {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<void> saveCurrencyList(List<CurrencyModel> value);
}
