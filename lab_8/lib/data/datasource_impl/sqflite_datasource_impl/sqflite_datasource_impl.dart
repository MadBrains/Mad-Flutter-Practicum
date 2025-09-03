import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasource_impl/table.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasource_impl/database_helper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasource_impl/mapper/mapper.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasourceImpl implements DbDatasource {
  final DatabaseHelper _helper = DatabaseHelper();

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final Database db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(CurrencyTable.name);

    return maps.map((e) => CurrencyModelDbMapper.fromMap(e)).toList(growable: false);
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    final Database db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(NewsTable.name);

    return maps.map((e) => NewsModelDbMapper.fromMap(e)).toList(growable: false);
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) async {
    final Database db = await _helper.database;
    final Batch batch = db.batch();

    for (final CurrencyModel item in value) {
      batch.insert(
        CurrencyTable.name,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    final Database db = await _helper.database;
    final Batch batch = db.batch();

    for (final NewsModel item in value) {
      batch.insert(
        NewsTable.name,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
