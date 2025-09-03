import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasorce_impl/table.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

const String _databaseName = 'app_database.db';
const int _databaseVersion = 1;

class DatabaseHelper {
  const DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String commonPath = join(databasesPath, _databaseName);

    return openDatabase(
      commonPath,
      version: _databaseVersion,
      onCreate: (Database db, _) async {
        await Future.wait([
          db.execute(CurrencyTable.creationRequest),
          db.execute(NewsTable.creationRequest),
        ]);
      },
    );
  }
}
