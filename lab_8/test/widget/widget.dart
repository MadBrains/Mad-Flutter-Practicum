import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildWidget({
  List<Provider> providers = const [],
  required Widget child,
}) =>
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: child,
      ),
    );
