import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/models/favorite_model.dart';
import 'package:news_reader/models/history_model.dart';
import 'package:news_reader/screens/article_screen.dart';
import 'package:news_reader/widgets/image_container.dart';
import 'package:news_reader/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

class ViewAllArticlesScreen extends StatelessWidget {
  const ViewAllArticlesScreen(
      {super.key,
      required this.articles,
      required this.favorite,
      required this.history});
  static const routeName = '/view';
  final List<Article> articles;
  final HistoryModel history;
  final Favorite favorite;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .background,
      appBar: AppBar(
        title: Text(
          'View All',
          style: Provider.of<ThemeProvider>(context)
              .getThemeData(context)
              .textTheme
              .displayMedium,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 120,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: articles.length - 1,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleScreen(
                          article: articles[index],
                          favorite: favorite,
                          history: history,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(articles[index].title!,
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  style: Provider.of<ThemeProvider>(context)
                                      .getThemeData(context)
                                      .textTheme
                                      .bodyLarge!),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      '${DateTime.now().difference(DateTime.parse(articles[index].publishedAt!)).inHours} hours ago',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  const Icon(
                                    Icons.visibility,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('1224 views',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ImageContainer(
                          width: 100,
                          height: 100,
                          borderRadius: 5,
                          imageUrl: articles[index].urlToImage!,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
