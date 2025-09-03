import 'dart:convert';

import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/app_http_client.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/model/model.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_path.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
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
