import 'package:flutter/material.dart';
import 'package:news_reader/models/favorite_model.dart';
import 'package:news_reader/models/history_model.dart';
import 'package:news_reader/screens/article_screen.dart';
import 'package:news_reader/widgets/image_container.dart';
import 'package:news_reader/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen(
      {super.key, required this.favorite, required this.history});
  final Favorite favorite;
  final HistoryModel history;

  static const routeName = '/following';

  @override
  Widget build(BuildContext context) {
    if (favorite.articles!.isEmpty && history.articles!.isEmpty) {
      return _EmptyHistoryandFavorite();
    } else {
      return _NotEmptyHistoryandFavorite(favorite: favorite, history: history);
    }
  }
}

class _NotEmptyHistoryandFavorite extends StatelessWidget {
  const _NotEmptyHistoryandFavorite({
    required this.favorite,
    required this.history,
  });

  final Favorite favorite;
  final HistoryModel history;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100, left: 20),
            child: Row(
              children: [
                Icon(Icons.favorite),
                SizedBox(width: 10),
                Text('Later Readings',
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .displayLarge),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favorite.articles!.length,
              separatorBuilder: (context, index) => SizedBox(height: 30),
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(left: 20, right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                              article: favorite.articles![index],
                              history: history,
                              favorite: favorite),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageContainer(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: favorite.articles![index].urlToImage!,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          favorite.articles![index].title!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateTime.now().difference(DateTime.parse(favorite.articles![index].publishedAt!)).inHours} hours ago',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Flexible(
                              child: Text(
                                ' by ${favorite.articles![index].author}',
                                style: Theme.of(context).textTheme.bodySmall,
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
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(Icons.history),
                SizedBox(width: 10),
                Text('History',
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .displayLarge),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: history.articles!.length,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(right: 10, left: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                              article: history.articles![index],
                              history: history,
                              favorite: favorite),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageContainer(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: history.articles![index].urlToImage!,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          history.articles![index].title!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateTime.now().difference(DateTime.parse(history.articles![index].publishedAt!)).inHours} hours ago',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Flexible(
                              child: Text(
                                ' by ${history.articles![index].author}',
                                style: Theme.of(context).textTheme.bodySmall,
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

class _EmptyHistoryandFavorite extends StatelessWidget {
  const _EmptyHistoryandFavorite();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100, left: 20),
          child: Row(
            children: [
              Icon(Icons.favorite),
              SizedBox(width: 10),
              Text('Later Readings',
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .displayLarge),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: Center(
            child: Text('Empty',
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .headlineSmall!),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 100, left: 20),
          child: Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 10),
              Text('History',
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .displayLarge),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: Center(
            child: Text('Empty',
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .headlineSmall!),
          ),
        ),
      ],
    ));
  }
}
