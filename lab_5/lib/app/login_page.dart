import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<SettingsRepository>().setToken(_generateRandomToken()),
          child: Text(
            'Войти',
            style: context.fonts.regular14,
          ),
        ),
      ),
    );
  }
}

String _generateRandomToken([int length = 32]) {
  const String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  final Random random = Random();

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}
