import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 128),
      ),
      backgroundColor: context.colors.primary,
    );
  }
}
