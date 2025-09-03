import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/data/data.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';
import 'package:mockito/mockito.dart';

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
