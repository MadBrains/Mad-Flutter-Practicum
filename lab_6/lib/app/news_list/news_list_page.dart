import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsModel>> _newsListFuture;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final newsRepository = context.read<NewsRepository>();

    _newsListFuture = newsRepository.getNewsList().then((List<NewsModel> value) {
      newsRepository.saveNewsList(value);

      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Новости')),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
          final List<NewsModel>? data = snapshot.data;
          if (data == null) return const SizedBox.shrink();

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final NewsModel news = data[index];

              return Padding(
                key: ValueKey(news.link),
                padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
                child: NewsCard(model: news),
              );
            },
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
          );
        },
      ),
    );
  }
}
