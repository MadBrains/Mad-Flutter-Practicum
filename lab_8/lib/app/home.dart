import 'package:mad_flutter_practicum/app/app.dart';

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
    final AppLocalizations loc = context.loc;

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
              label: loc.currencyRate,
            ),
            BottomNavigationBarItem(
              icon: TabWidget(
                assetPath: 'assets/icons/news.png',
                isSelected: currentPage is NewsListPage,
              ),
              label: loc.news,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: loc.profile,
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
