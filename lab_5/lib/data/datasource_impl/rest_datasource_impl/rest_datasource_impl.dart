import 'dart:convert';

import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/app_http_client.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/currency_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/news_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/model/currency_dto.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_path.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:rss_dart/dart_rss.dart';

class RestDatasourceImpl implements RestDatasource {
  late final AppHttpClient _httpClient = AppHttpClient();

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final String? response = await _httpClient.getDecodedResponse(RestPath.dailyExchangeRateUrl);
    if (response == null) return const <CurrencyModel>[];

    final Map<String, dynamic> json = jsonDecode(response);

    return CurrencyListResponseDto.fromJson(json).valute.values.map((e) => e.model).toList(growable: false);
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    final String? response = await _httpClient.getDecodedResponse(RestPath.newsUrl);
    if (response == null) return const <NewsModel>[];

    return RssFeed.parse(response).items.map((e) => e.asNewsModel).toList(growable: false);
  }
}
