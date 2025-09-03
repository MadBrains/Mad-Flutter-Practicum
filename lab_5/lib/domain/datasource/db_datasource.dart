import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';

abstract interface class DbDatasource {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<List<NewsModel>> getNewsList();

  Future<void> saveCurrencyList(List<CurrencyModel> value);

  Future<void> saveNewsList(List<NewsModel> value);
}
