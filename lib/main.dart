import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/models/news.dart';
import 'package:news_reader/screens/article_screen.dart';
import 'package:news_reader/screens/following_screen.dart';
import 'package:news_reader/screens/forgot_pasword_screen.dart';
import 'package:news_reader/screens/home_screen.dart';
import 'package:news_reader/screens/login_screen.dart';
import 'package:news_reader/screens/register_screen.dart';
import 'package:news_reader/screens/search_screen.dart';
import 'package:news_reader/screens/setting_screen.dart';
import 'package:news_reader/screens/view_all_screen.dart';
import 'package:news_reader/widgets/bottom_nav_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles = [];
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
              articles: articles, key: PageStorageKey<String>('HomeScreen')),
          SearchScreen(
              articles: articles, key: PageStorageKey<String>('SearchScreen')),
          FollowingScreen(key: PageStorageKey<String>('FollowingScreen')),
          SettingScreen(key: PageStorageKey<String>('SettingScreen')),
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
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: pages![currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withAlpha(100),
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
