import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/constants.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/news_mapper.dart';
import 'package:rss_dart/domain/rss_item.dart';
import 'package:intl/intl.dart';

void main() {
  group('RssItem to NewsModel mapping', () {
    test('maps valid RssItem with complete data correctly', () {
      final rssItem = RssItem(
        title: 'Test title',
        link: 'https://example.com/news',
        pubDate: 'Fri, 21 Jun 2024 12:00:00 +0300',
      );

      final model = rssItem.asNewsModel;

      expect(model.title, 'Test title');
      expect(model.link, 'https://example.com/news');
      expect(
        model.date,
        DateFormat(RestConstants.newsDateTimeFormat).parse('Fri, 21 Jun 2024 12:00:00 +0300'),
      );
    });

    test('handles null fields with default values', () {
      final rssItem = RssItem(
        title: null,
        link: null,
        pubDate: null,
      );

      final model = rssItem.asNewsModel;

      expect(model.title, '');
      expect(model.link, '');
      expect(model.date, isNull);
    });
  });
}
