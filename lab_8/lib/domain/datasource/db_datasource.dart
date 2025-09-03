import 'package:mad_flutter_practicum/domain/model/model.dart';

abstract interface class DbDatasource {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<List<NewsModel>> getNewsList();

  Future<void> saveCurrencyList(List<CurrencyModel> value);

  Future<void> saveNewsList(List<NewsModel> value);
}
