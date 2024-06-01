import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/firebase_collections.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/screens/article_screen.dart";
import "package:news_reader/screens/view_all_screen.dart";
import "package:news_reader/widgets/custom_tag.dart";
import "package:news_reader/controllers/firebase_alteration.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static const routeName = "/";
  final List<Article> articles;
  late DocumentReference<Map<String, dynamic>> favorite;
  late DocumentReference<Map<String, dynamic>> history;

  HomeScreen({
    super.key,
    required this.articles,
    required this.favorite,
    required this.history,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _articles = News.news;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        Provider.of<ThemeProvider>(context).getThemeData(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        color: isDarkMode ? Colors.white : Colors.black,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        onRefresh: () async {
          await News().getNews();
          setState(() {});
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _NewsOfTheDay(
              articles: _articles,
              history: widget.history,
              favorite: widget.favorite,
            ),
            _BreakingNews(
              articles: _articles,
              history: widget.history,
              favorite: widget.favorite,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _BreakingNews extends StatelessWidget {
  _BreakingNews({
    required this.articles,
    required this.history,
    required this.favorite,
  });
  final List<Article> articles;
  late DocumentReference<Map<String, dynamic>> favorite;
  late DocumentReference<Map<String, dynamic>> history;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Breaking News",
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleLarge,
              ),
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
                child: Text(
                  "More",
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .titleLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.475,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: 9,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              padding: EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () async {
                      articles[index + 1].view =
                          (int.parse(articles[index + 1].view!) + 1).toString();
                      await updateFieldInFirebase(
                        "article",
                        articles[index + 1].id!,
                        "view",
                        int.parse(articles[index + 1].view!),
                      );
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
                      final historyData = await history.get();
                      final articleExistence =
                          historyData.data()!["articles"][0]["article"];
                      if (articleExistence == "") {
                        history.update({
                          "articles": ([
                            {
                              "article": FirebaseFirestore.instance
                                  .collection("article")
                                  .doc(articles[index + 1].id!),
                              "dateRead": Timestamp.now(),
                            }
                          ]),
                        });
                      } else {
                        List<dynamic> existingArticleIds = historyData
                            .data()!["articles"]
                            .map((article) => article["article"].id)
                            .toList();

                        // Check if the article exists
                        if (!existingArticleIds
                            .contains(articles[index + 1].id)) {
                          // If the article doesn't exist, update the articles field
                          history.update({
                            "articles": FieldValue.arrayUnion([
                              {
                                "article": FirebaseFirestore.instance
                                    .collection("article")
                                    .doc(articles[index + 1].id!),
                                "dateRead": Timestamp.now(),
                              }
                            ]),
                          });
                        }
                      }
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
                        Text(
                          articles[index + 1].title!,
                          style: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .textTheme
                              .bodyLarge!,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${articles[index + 1].publishedAt}",
                              style: Provider.of<ThemeProvider>(context)
                                  .getThemeData(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                            Flexible(
                              child: Text(
                                " by ${articles[index + 1].author}",
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
  final dynamic history;
  final dynamic favorite;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        articles[0].view = (int.parse(articles[0].view!) + 1).toString();
        await updateFieldInFirebase(
          "article",
          articles[0].id!,
          "view",
          int.parse(
            articles[0].view!,
          ),
        );
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
        final historyData = await history.get();
        final articleExistence = historyData.data()!["articles"][0]["article"];
        if (articleExistence == "") {
          history.update({
            "articles": ([
              {
                "article": FirebaseFirestore.instance
                    .collection("article")
                    .doc(articles[0].id!),
                "dateRead": Timestamp.now(),
              }
            ]),
          });
        } else {
          List<dynamic> existingArticleIds = historyData
              .data()!["articles"]
              .map((article) => article["article"].id)
              .toList();

          // Check if the article exists
          if (!existingArticleIds.contains(articles[0].id)) {
            // If the article doesn't exist, update the articles field
            history.update({
              "articles": FieldValue.arrayUnion([
                {
                  "article": FirebaseFirestore.instance
                      .collection("article")
                      .doc(articles[0].id!),
                  "dateRead": Timestamp.now(),
                }
              ]),
            });
          }
        }
      },
      child: ImageContainer(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        imageUrl: articles[0].urlToImage!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              backgroundColor: Colors.grey.withAlpha(191),
              children: [
                Text(
                  "News of the Day",
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              articles[0].title!,
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(191, 0, 0, 0),
                    offset: Offset(1, 1),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(
                    "Learn More",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(191, 0, 0, 0),
                          offset: Offset(1, 1),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(191, 0, 0, 0),
                        offset: Offset(1, 1),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
