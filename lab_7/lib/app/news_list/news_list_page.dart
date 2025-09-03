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

class _NewsListPageState extends State<NewsListPage> with SingleTickerProviderStateMixin {
  static final _tween = Tween<double>(begin: 0.25, end: 1);

  late Future<List<NewsModel>> _newsListFuture;

  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initData();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = _tween.animate(_scaleController);
  }

  void _initData() {
    final newsRepository = context.read<NewsRepository>();

    _newsListFuture = newsRepository.getNewsList().then((List<NewsModel> value) {
      newsRepository.saveNewsList(value);

      _scaleController.forward(); // запускаем анимацию

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

          return ScaleTransition(
            scale: _scaleAnimation,
            child: ListView.builder(
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
            ),
          );
        },
      ),
    );
  }
}
