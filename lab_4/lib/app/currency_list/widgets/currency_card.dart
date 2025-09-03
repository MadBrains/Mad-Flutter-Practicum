import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_detail/currency_detail_page.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

enum PriceChange {
  up,
  down,
  stable;
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({super.key, required this.model});

  final CurrencyModel model;

  @override
  Widget build(BuildContext context) {
    final PriceChange priceChange = model.asPriceChange;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CurrencyDetailPage(title: model.name)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CurrencyIcon(title: model.symbol),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  model.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Text(
              model.value.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: switch (priceChange) {
                  PriceChange.up => const Color(0xFF1FD522),
                  PriceChange.down => const Color(0xFFFF0000),
                  PriceChange.stable => const Color(0xFF7C7B7B),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 6),
              child: Text(
                '(${model.nominal} шт.)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              switch (priceChange) {
                PriceChange.up => 'assets/icons/arrow_up.png',
                PriceChange.down => 'assets/icons/arrow_down.png',
                PriceChange.stable => 'assets/icons/arrow_up.png',
              },
              width: 10,
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyIcon extends StatelessWidget {
  const CurrencyIcon({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(Size.square(40)),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'InterTight',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

extension on CurrencyModel {
  PriceChange get asPriceChange {
    if (value > previousValue) return PriceChange.up;
    if (value < previousValue) return PriceChange.down;

    return PriceChange.stable;
  }
}
