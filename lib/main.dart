import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/models/news.dart';
import 'package:news_reader/screens/article_screen.dart';
import 'package:news_reader/screens/home_screen.dart';
import 'package:news_reader/screens/search_screen.dart';
import 'package:news_reader/screens/setting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // Fetch news articles
  Future<List<Article>> _fetchNews() async {
    News newsService = News();
    await newsService.getNews();
    return newsService.news;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Reader',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.deepPurple,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<List<Article>>(
              future: _fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else {
                  // Pass articles to the home screen
                  return HomeScreen(articles: snapshot.data!);
                }
              },
            ),
        SearchScreen.routeName: (context) => FutureBuilder<List<Article>>(
              future: _fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else {
                  // Pass articles to the search screen
                  return SearchScreen(articles: snapshot.data!);
                }
              },
            ),
        SettingScreen.routeName: (context) => const SettingScreen(),
        ArticleScreen.routeName: (context) => const ArticleScreen(),
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
