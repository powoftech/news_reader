
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/news.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/screens/following_screen.dart";
import "package:news_reader/screens/home_screen.dart";
import "package:news_reader/screens/search_screen.dart";
import "package:news_reader/screens/setting_screen_user.dart";
import "package:news_reader/screens/waiting_screen.dart";
import "package:news_reader/widgets/theme_provider.dart";

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  List<Article> articles = [];
  late DocumentReference<Map<String, dynamic>> favorite;
  late DocumentReference<Map<String, dynamic>> history;
  List<Widget>? pages;
  List<String>? uniqueTopics;
  String user = "";
  Future<void> _fetchNews() async {
    News newsService = News();
    await newsService.getNews();
    articles = News.news;
    uniqueTopics = newsService.allTopics.toList();
    history = newsService.history;
    favorite = newsService.favorite;
  }

  @override
  void initState() {
    super.initState();

    _fetchNews().then((_) {
      setState(() {
        pages = [
          HomeScreen(
            articles: articles,
            favorite: favorite,
            history: history,
            key: PageStorageKey<String>("HomeScreen"),
          ),
          SearchScreen(
            articles: articles,
            favorite: favorite,
            history: history,
            uniqueTopics: uniqueTopics,
            key: PageStorageKey<String>("SearchScreen"),
          ),
          FollowingScreen(
            articles: articles,
            favorite: favorite,
            history: history,
            key: PageStorageKey<String>("FollowingScreen"),
          ),
          SettingScreenUser(
            key: PageStorageKey<String>("SettingScreen"),
          ),
        ];
      });
    });
  }

  int currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider().getThemeData(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;

    if (pages == null) {
      return WaitingScreen(isDarkMode: isDarkMode);
    }

    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: pages![currentTab],
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
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Following",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
