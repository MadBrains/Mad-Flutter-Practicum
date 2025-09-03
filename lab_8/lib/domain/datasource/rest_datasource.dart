import 'package:mad_flutter_practicum/domain/model/model.dart';

abstract interface class RestDatasource {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<List<NewsModel>> getNewsList();
}
