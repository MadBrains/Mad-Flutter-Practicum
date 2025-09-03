import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';
import 'package:mad_flutter_practicum/app/profile/profile_page.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';

import 'news_list/news_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    CurrencyListPage(),
    NewsListPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget currentPage = _pages[_selectedIndex];

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: context.colors.bottomNavBarShadow,
              blurRadius: 25,
              offset: Offset(0.0, 0.75),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: TabWidget(
                assetPath: 'assets/icons/home.png',
                isSelected: currentPage is CurrencyListPage,
              ),
              label: 'Курс Валют',
            ),
            BottomNavigationBarItem(
              icon: TabWidget(
                assetPath: 'assets/icons/news.png',
                isSelected: currentPage is NewsListPage,
              ),
              label: 'Новости',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    super.key,
    required this.assetPath,
    required this.isSelected,
  });

  final String assetPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;

    return SizedBox.square(
      dimension: 24,
      child: Image.asset(
        assetPath,
        color: isSelected ? colors.bottomNavBarSelectedItem : colors.bottomNavBarUnselectedItem,
      ),
    );
  }
}
