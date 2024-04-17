import 'package:flutter/material.dart';
import 'package:news_reader/screens/following_screen.dart';
import 'package:news_reader/screens/home_screen.dart';
import 'package:news_reader/screens/search_screen.dart';
import 'package:news_reader/screens/setting_screen.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentTab,
  });
  final int currentTab;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTab,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withAlpha(100),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Following',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        ),
      ],
    );
  }
}
