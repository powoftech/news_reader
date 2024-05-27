import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/screens/article_screen.dart";
import "package:news_reader/controllers/firebase_alteration.dart";
import "package:news_reader/screens/search_result.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class SearchScreen extends StatelessWidget {
  static const routeName = "/discover";
  final List<Article> articles;
  final dynamic history;
  final dynamic favorite;
  final List<String>? uniqueTopics;
  const SearchScreen(
      {super.key,
      required this.articles,
      required this.history,
      required this.favorite,
      required this.uniqueTopics});
  @override
  Widget build(BuildContext context) {
    List<String> tabs = uniqueTopics!;
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getThemeData(context)
            .colorScheme
            .surface,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
          child: ListView(
            children: [
              _DiscoverNews(
                articles: articles,
                history: history,
                favorite: favorite,
              ),
              _CategoryNews(
                  tabs: tabs,
                  articles: articles,
                  favorite: favorite,
                  history: history),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<Widget> tabs;

  CustomTabBar({required this.tabs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: tab,
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({
    required this.tabs,
    required this.articles,
    required this.favorite,
    required this.history,
  });
  final List<String> tabs;
  final List<Article> articles;
  final dynamic favorite;
  final dynamic history;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: tabs
                .map(
                  (tab) => Tab(
                    icon: Text(
                      tab,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                .toList()),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: TabBarView(
            children: tabs.map((tab) {
              final filteredArticles = articles
                  .where(
                      (article) => article.topic!.contains(tab.toLowerCase()))
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final currentArticle = filteredArticles[index];
                  return InkWell(
                    onTap: () async {
                      currentArticle.view =
                          (int.parse(currentArticle.view!) + 1).toString();
                      await updateFieldInFirebase(
                        "article",
                        currentArticle.id!,
                        "view",
                        int.parse(currentArticle.view!),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                            article: currentArticle,
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
                                  .doc(articles[index].id!),
                              "dateRead": Timestamp.now(),
                            }
                          ])
                        });
                      } else {
                        List<dynamic> existingArticleIds = historyData
                            .data()!["articles"]
                            .map((article) => article["article"].id)
                            .toList();

                        // Check if the article exists
                        if (!existingArticleIds.contains(articles[index].id)) {
                          // If the article doesn't exist, update the articles field
                          history.update({
                            "articles": FieldValue.arrayUnion([
                              {
                                "article": FirebaseFirestore.instance
                                    .collection("article")
                                    .doc(articles[index].id!),
                                "dateRead": Timestamp.now(),
                              }
                            ])
                          });
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ImageContainer(
                            width: 80,
                            height: 80,
                            borderRadius: 5,
                            imageUrl: currentArticle.urlToImage!,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentArticle.title!,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: Provider.of<ThemeProvider>(context)
                                    .getThemeData(context)
                                    .textTheme
                                    .bodyLarge!,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.schedule, size: 18),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "${currentArticle.publishedAt}",
                                      style: Provider.of<ThemeProvider>(context)
                                          .getThemeData(context)
                                          .textTheme
                                          .bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.visibility, size: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${currentArticle.view} views",
                                    style: Provider.of<ThemeProvider>(context)
                                        .getThemeData(context)
                                        .textTheme
                                        .bodyMedium,
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews({
    required this.articles,
    required this.favorite,
    required this.history,
  });
  final List<Article> articles;
  final dynamic favorite;
  final dynamic history;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Discover",
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .headlineLarge),
          const SizedBox(
            height: 5,
          ),
          Text(
            "News from all over the world",
            style: Provider.of<ThemeProvider>(context)
                .getThemeData(context)
                .textTheme
                .bodyMedium,
          ),
          const SizedBox(height: 20),
          Form(
            child: TextFormField(
              onFieldSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchArticleScreen(
                      articles: articles,
                      history: history,
                      favorite: favorite,
                      keyword: value,
                    ),
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: "Search for news",
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: RotatedBox(
                  quarterTurns: 1,
                  child: const Icon(
                    Icons.tune,
                    color: Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
