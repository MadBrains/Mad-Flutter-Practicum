import 'package:mockito/annotations.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

@GenerateMocks([CurrencyRepository, NewsRepository, SettingsRepository])
void main() {}
