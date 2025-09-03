import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/app/login_page.dart';
import 'package:mad_flutter_practicum/data/repository_impl/settings_repository_impl.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/datasource.mocks.dart';

import 'widget.dart';

void main() {
  final MockPreferenceDatasource mockPreferenceDatasource = MockPreferenceDatasource();

  late SettingsRepository settingsRepository;

  setUp(() {
    settingsRepository = SettingsRepositoryImpl(mockPreferenceDatasource);
  });

  group('LoginPage', () {
    testWidgets('should call setToken when login button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          providers: [
            Provider<SettingsRepository>.value(value: settingsRepository),
          ],
          child: const LoginPage(),
        ),
      );

      final loginButton = find.text('Войти');
      expect(loginButton, findsOneWidget);

      verifyNever(settingsRepository.setToken(any));

      await tester.tap(loginButton);

      verify(settingsRepository.setToken(any)).called(1);
    });
  });
}
