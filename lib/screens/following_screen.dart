import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/firebase_alteration.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/screens/article_screen.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

// ignore: must_be_immutable
class FollowingScreen extends StatelessWidget {
  FollowingScreen({
    super.key,
    required this.favorite,
    required this.history,
    required this.articles,
  });
  DocumentReference<Map<String, dynamic>> favorite;
  DocumentReference<Map<String, dynamic>> history;
  final List<Article> articles;
  static const routeName = "/following";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([favorite.get(), history.get()]),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DocumentSnapshot>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
          ); // Show error if there is any
        } else {
          dynamic favoriteData = snapshot.data![0].data();
          dynamic historyData = snapshot.data![1].data();
          final articlesFavorite = favoriteData["articles"];
          final articlesHistory = historyData["articles"];

          return _NotEmptyHistoryAndFavorite(
            favorite: articlesFavorite,
            history: articlesHistory,
            articles: articles,
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class _NotEmptyHistoryAndFavorite extends StatelessWidget {
  _NotEmptyHistoryAndFavorite({
    required this.articles,
    required this.favorite,
    required this.history,
  });
  final List<Article> articles;
  final favorite;
  final history;

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
                Text(
                  "Later Readings",
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .displayLarge,
                ),
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
              itemCount: favorite.length,
              separatorBuilder: (context, index) => SizedBox(height: 30),
              itemBuilder: (context, index) {
                if (favorite[index]["article"] == "") {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Empty",
                        style: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .textTheme
                            .headlineSmall!,
                      ),
                    ),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(left: 20, right: 10),
                  child: GestureDetector(
                    onLongPressStart: (_) => Provider.of<DeleteMode>(context,
                            listen: false)
                        .activateDeleteMode(), // Activate global delete mode
                    onLongPressEnd: (_) => handleDeleteArticle(
                        getArticleById(articles, favorite["article"].id),
                        context), // Handle individual article deletion
                    onTap: () async {
                      getArticleById(
                        articles,
                        favorite[index]["article"].id,
                      ).view = (
                        int.parse(
                              getArticleById(
                                articles,
                                favorite[index]["article"].id,
                              ).view!,
                            ) +
                            1,
                      ).toString();
                      await updateFieldInFirebase(
                        "article",
                        favorite[index]["article"].id,
                        "view",
                        int.parse(
                          getArticleById(
                            articles,
                            favorite[index]["article"].id,
                          ).view!,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                            article: getArticleById(
                              articles,
                              favorite[index]["article"].id,
                            ),
                            history: history,
                            favorite: favorite,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageContainer(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: getArticleById(
                            articles,
                            favorite[index]["article"].id,
                          ).urlToImage!,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getArticleById(
                            articles,
                            favorite[index]["article"].id,
                          ).title!,
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
                              "${getArticleById(
                                articles,
                                favorite[index]["article"].id,
                              ).publishedAt} hours ago",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Flexible(
                              child: Text(
                                " by ${getArticleById(
                                  articles,
                                  favorite[index]["article"].id,
                                ).author}",
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (Provider.of<DeleteMode>(context)
                            .isDeleteModeActive) // Show delete icon based on global state
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => handleDeleteArticle(
                                  favorite[index]["article"], context),
                            ),
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
                Text(
                  "History",
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .displayLarge,
                ),
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
              itemCount: history.length,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                if (history[index]["article"] == "") {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Empty",
                        style: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .textTheme
                            .headlineSmall!,
                      ),
                    ),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(right: 10, left: 20),
                  child: InkWell(
                    onTap: () async {
                      getArticleById(articles, history[index]["article"].id)
                          .view = (int.parse(
                                getArticleById(
                                  articles,
                                  history[index]["article"].id,
                                ).view!,
                              ) +
                              1)
                          .toString();
                      await updateFieldInFirebase(
                        "article",
                        getArticleById(articles, history[index]["article"].id)
                            .id!,
                        "view",
                        int.parse(
                          getArticleById(
                            articles,
                            history[index]["article"].id,
                          ).view!,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                            article: getArticleById(
                              articles,
                              history[index]["article"].id,
                            ),
                            history: history,
                            favorite: favorite,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageContainer(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: getArticleById(
                            articles,
                            history[index]["article"].id,
                          ).urlToImage!,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getArticleById(articles, history[index]["article"].id)
                              .title!,
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
                              "${getArticleById(articles, history[index]["article"].id).publishedAt}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Flexible(
                              child: Text(
                                " by ${getArticleById(articles, history[index]["article"].id).author}",
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
