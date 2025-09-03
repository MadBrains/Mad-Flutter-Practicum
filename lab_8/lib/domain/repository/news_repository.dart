import 'package:mad_flutter_practicum/domain/model/news_model.dart';

abstract interface class NewsRepository {
  Future<List<NewsModel>> getNewsList();

  Future<void> saveNewsList(List<NewsModel> value);
}
