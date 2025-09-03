// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get currencyRate => 'Курс Валют';

  @override
  String get news => 'Новости';

  @override
  String get profile => 'Профиль';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get search => 'Поиск';

  @override
  String asNominal(Object value) {
    return '($value шт.)';
  }
}
