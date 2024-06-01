import "package:flutter/material.dart";
import "package:news_reader/screens/history_screen.dart";
import "package:news_reader/screens/news_screen.dart";
import "package:news_reader/screens/read_later_screen.dart";
import "package:news_reader/screens/search_screen.dart";
import "package:news_reader/screens/setting_screen.dart";
import "package:news_reader/widgets/provider.dart";

/// The main screen of the app that displays different screens based on the selected tab.
class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final List<Widget> pages = const <Widget>[
    NewsScreen(key: PageStorageKey("HomeScreen")),
    SearchScreen(key: PageStorageKey<String>("SearchScreen")),
    HistoryScreen(key: PageStorageKey("HistoryScreen")),
    ReadLaterScreen(key: PageStorageKey("ReadLaterScreen")),
    SettingScreen(key: PageStorageKey<String>("SettingScreen")),
  ];

  @override
  void initState() {
    super.initState();
  }

  int currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider().getThemeData(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageStorage(
        bucket: _bucket,
        child: pages[currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: isDarkMode ? Colors.white : Colors.black,
        unselectedItemColor: isDarkMode
            ? Colors.white.withAlpha(100)
            : Colors.black.withAlpha(100),
        onTap: (int index) {
          setState(() {
            currentTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "ReadLater",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
