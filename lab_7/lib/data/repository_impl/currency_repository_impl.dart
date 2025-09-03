import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._restDatasource, this._dbDatasource);

  final RestDatasource _restDatasource;
  final DbDatasource _dbDatasource;

  @override
  Future<List<CurrencyModel>> getCurrencyList() => _restDatasource.getCurrencyList();

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) => _dbDatasource.saveCurrencyList(value);
}
