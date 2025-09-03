import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._rest);

  final RestDatasource _rest;

  @override
  Future<List<CurrencyModel>> getCurrencyList() => _rest.getCurrencyList();
}
