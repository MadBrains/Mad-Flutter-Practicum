abstract class CurrencyTable {
  static const String name = 'currencies';
  static const String creationRequest = '''
          CREATE TABLE $name (
            id TEXT PRIMARY KEY,
            name TEXT,
            symbol TEXT,
            value REAL,
            nominal INTEGER,
            previousValue REAL
          )
        ''';
}

abstract class NewsTable {
  static const String name = 'news';
  static const String creationRequest = '''
          CREATE TABLE $name (
            id INTEGER PRIMARY KEY autoincrement,
            title TEXT,
            link TEXT,
            date TEXT
          )
        ''';
}
