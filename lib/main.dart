import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_reader/auth.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/models/favorite_model.dart';
import 'package:news_reader/models/history_model.dart';
import 'package:news_reader/models/news.dart';
import 'package:news_reader/screens/following_screen.dart';
import 'package:news_reader/screens/forgot_password_screen.dart';
import 'package:news_reader/screens/home_screen.dart';
import 'package:news_reader/screens/login_screen.dart';
import 'package:news_reader/screens/register_screen.dart';
import 'package:news_reader/screens/search_screen.dart';
import 'package:news_reader/screens/setting_screen.dart';
import 'package:news_reader/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      // Wrap MyApp with ChangeNotifierProvider
      create: (context) =>
          ThemeProvider(), // Provide an instance of ThemeProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getThemeData(context),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Auth auth = Auth();

  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
  }
  
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
