import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3929C7);
    const backgroundColor = Color(0xFFf2f2f2);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
      ),
      home: CurrencyListPage(),
    );
  }
}
