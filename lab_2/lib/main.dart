import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3929C7);
    const backgroundColor = Color(0xFFf2f2f2);
    const secondaryColor = Color(0xFF7F7F7F);

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
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: primaryColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: secondaryColor,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
