import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([RestDatasource, DbDatasource, PreferenceDatasource])
void main() {}
