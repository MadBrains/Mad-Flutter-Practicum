import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/search_view.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:provider/provider.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  late final ValueNotifier<List<CurrencyModel>> _filteredCurrenciesNotifier;

  late Future<List<CurrencyModel>> _currencyListFuture;

  List<CurrencyModel> _allCurrencies = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _filteredCurrenciesNotifier.dispose();
    super.dispose();
  }

  void _initData() {
    _currencyListFuture = context.read<CurrencyRepository>().getCurrencyList().then((List<CurrencyModel> value) {
      _allCurrencies = value;
      _filteredCurrenciesNotifier = ValueNotifier(value);

      return value;
    });
  }

  void _filterCurrencies(String query) {
    final String lowerQuery = query.toLowerCase();
    final Iterable<CurrencyModel> result = _allCurrencies.where((CurrencyModel currency) {
      return currency.name.toLowerCase().contains(lowerQuery) || currency.symbol.toLowerCase().contains(lowerQuery);
    });

    _filteredCurrenciesNotifier.value = result.toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Курс Валют'),
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: _currencyListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<CurrencyModel>> snapshot) {
          final List<CurrencyModel>? data = snapshot.data;
          if (data == null) return const SizedBox.shrink();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                child: SearchView(onChanged: _filterCurrencies),
              ),
              Expanded(
                child: ValueListenableBuilder<List<CurrencyModel>>(
                  valueListenable: _filteredCurrenciesNotifier,
                  builder: (BuildContext context, List<CurrencyModel> data, _) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final CurrencyModel currency = data[index];

                        return Padding(
                          key: ValueKey(currency.id),
                          padding: index == 0 ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 10),
                          child: CurrencyCard(model: currency),
                        );
                      },
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 40),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
