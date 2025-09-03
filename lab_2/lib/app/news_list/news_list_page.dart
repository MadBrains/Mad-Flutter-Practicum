import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новости'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
        child: Column(
          children: [
            for (int i = 0; i < 5; i++)
              Padding(
                padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
                child: NewsCard(),
              ),
          ],
        ),
      ),
    );
  }
}
