import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_detail/widgets/currency_info_card.dart';
import 'package:mad_flutter_practicum/app/currency_tab_container/currency_tab_state.dart';
import 'package:provider/provider.dart';

class CurrencyDetailPage extends StatelessWidget {
  const CurrencyDetailPage({super.key, required this.title});

  final String title;

  static const double _defaultLeadingWidth = 56;
  static const double _titleSpacing = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: _defaultLeadingWidth + _titleSpacing,
        titleSpacing: _titleSpacing,
        leading: IconButton(
          onPressed: () => context.read<CurrencyTabState>().removePage(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
        child: Column(
          children: [
            for (int i = 0; i < 5; i++)
              Padding(
                padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
                child: CurrencyInfoCard(),
              ),
          ],
        ),
      ),
    );
  }
}
