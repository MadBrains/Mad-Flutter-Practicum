import 'package:flutter/material.dart';

class CurrencyTabState extends ChangeNotifier {
  CurrencyTabState(this._pages);

  late final List<Widget> _pages;

  List<Widget> get pages => List<Widget>.unmodifiable(_pages);

  void addPage(Widget page) {
    _pages.add(page);
    notifyListeners();
  }

  void removePage() {
    _pages.removeLast();
    notifyListeners();
  }
}
