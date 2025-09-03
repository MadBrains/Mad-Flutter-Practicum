import 'package:intl/intl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/constants.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:rss_dart/domain/rss_item.dart';

extension NewsItemMapper on RssItem {
  NewsModel get asNewsModel {
    final String? pubDate = this.pubDate;

    return NewsModel(
      title: title ?? '',
      link: link ?? '',
      date: pubDate == null ? null : DateFormat(RestConstants.newsDateTimeFormat).parse(pubDate),
    );
  }
}
