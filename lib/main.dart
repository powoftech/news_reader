import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/models/favorite_model.dart';
import 'package:news_reader/models/history_model.dart';
import 'package:news_reader/models/news.dart';
import 'package:news_reader/screens/following_screen.dart';
import 'package:news_reader/screens/forgot_pasword_screen.dart';
import 'package:news_reader/screens/home_screen.dart';
import 'package:news_reader/screens/login_screen.dart';
import 'package:news_reader/screens/register_screen.dart';
import 'package:news_reader/screens/search_screen.dart';
import 'package:news_reader/screens/setting_screen.dart';
import 'package:news_reader/widgets/theme_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeProvider().getThemeData(context),
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles = [];
  Favorite favorite = Favorite(id: '1', articles: []);
  HistoryModel history = HistoryModel(id: '1', articles: []);
  List<Widget>? pages;

  Future<List<Article>> _fetchNews() async {
    News newsService = News();
    await newsService.getNews();
    return newsService.news;
  }

  @override
  void initState() {
    super.initState();
    _fetchNews().then((value) {
      setState(() {
        articles = value;
        pages = [
          HomeScreen(
              articles: articles,
              favorite: favorite,
              history: history,
              key: PageStorageKey<String>('HomeScreen')),
          SearchScreen(
              articles: articles,
              favorite: favorite,
              history: history,
              key: PageStorageKey<String>('SearchScreen')),
          FollowingScreen(
              favorite: favorite,
              history: history,
              key: PageStorageKey<String>('FollowingScreen')),
          SettingScreen(key: PageStorageKey<String>('SettingScreen')),
          LoginScreen(key: PageStorageKey<String>('LoginScreen')),
          RegisterScreen(key: PageStorageKey<String>('RegisterScreen')),
          ForgotPasswordScreen(
              key: PageStorageKey<String>('ForgotPasswordScreen')),
        ];
      });
    });
  }

  int currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    if (pages == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or any loading indicator
        ),
      );
    }
    ThemeData themeData = ThemeProvider().getThemeData(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;
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
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
