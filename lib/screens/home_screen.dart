import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/models/favorite_model.dart';
import 'package:news_reader/models/history_model.dart';
import 'package:news_reader/screens/article_screen.dart';
import 'package:news_reader/screens/view_all_screen.dart';
import 'package:news_reader/widgets/custom_tag.dart';
import 'package:news_reader/widgets/image_container.dart';
import 'package:news_reader/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  final List<Article> articles;
  final Favorite favorite;
  final HistoryModel history;
  const HomeScreen(
      {super.key,
      required this.articles,
      required this.favorite,
      required this.history});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        Provider.of<ThemeProvider>(context).getThemeData(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _NewsOfTheDay(
              articles: articles, history: history, favorite: favorite),
          _BreakingNews(
              articles: articles, history: history, favorite: favorite),
        ],
      ),
    );
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    required this.articles,
    required this.history,
    required this.favorite,
  });
  final List<Article> articles;
  final HistoryModel history;
  final Favorite favorite;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Breaking News',
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .titleLarge),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAllArticlesScreen(
                        articles: articles,
                        favorite: favorite,
                        history: history,
                      ),
                    ),
                  );
                },
                child: Text('More',
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .titleLarge),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 350,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: 9,
              separatorBuilder: (context, index) => SizedBox(height: 40),
              padding: EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                            article: articles[index + 1],
                            favorite: favorite,
                            history: history,
                          ),
                        ),
                      );
                      history.articles?.add(articles[index + 1]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageContainer(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: articles[index + 1].urlToImage!,
                        ),
                        const SizedBox(height: 10),
                        Text(articles[index + 1].title!,
                            style: Provider.of<ThemeProvider>(context)
                                .getThemeData(context)
                                .textTheme
                                .bodyLarge!),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateTime.now().difference(DateTime.parse(articles[index + 1].publishedAt!)).inHours} hours ago',
                              style: Provider.of<ThemeProvider>(context)
                                  .getThemeData(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                            Flexible(
                              child: Text(
                                ' by ${articles[index + 1].author}',
                                style: Provider.of<ThemeProvider>(context)
                                    .getThemeData(context)
                                    .textTheme
                                    .bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    required this.articles,
    required this.history,
    required this.favorite,
  });

  final List<Article> articles;
  final HistoryModel history;
  final Favorite favorite;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleScreen(
              article: articles[0],
              favorite: favorite,
              history: history,
            ),
          ),
        );
        history.articles?.add(articles[0]);
      },
      child: ImageContainer(
        height: MediaQuery.of(context).size.height * 0.45,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        imageUrl: articles[0].urlToImage!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              backgroundColor: Colors.grey.withAlpha(150),
              children: [
                Text('News of the Day',
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 10),
            Text(articles[0].title!,
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text('Learn More',
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white)),
                  const SizedBox(width: 10),
                  Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
