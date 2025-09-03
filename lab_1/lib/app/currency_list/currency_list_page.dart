import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/search_view.dart';

class CurrencyListPage extends StatelessWidget {
  const CurrencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Курс Валют')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SearchView(),
            ),
            for (int i = 0; i < 5; i++)
              Padding(
                padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
                child: CurrencyCard(),
              ),
          ],
        ),
      ),
    );
  }
}
