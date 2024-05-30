import "dart:async";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/screens/comment_screen.dart";
import "package:news_reader/widgets/comment.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

import "package:webview_flutter/webview_flutter.dart";

class ArticleScreen extends StatelessWidget {
  ArticleScreen({
    super.key,
    required this.article,
    required this.favorite,
    required this.history,
  });
  final dynamic article;
  final dynamic favorite;
  final dynamic history;
  static const routeName = "/article";

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> controller =
        Completer<WebViewController>();
    return FutureBuilder(
      future: Future.wait([
        Future.value(favorite.get()), // Wrap in Future.value if necessary
        Future.value(history.get()), // Wrap in Future.value if necessary
        FirebaseFirestore.instance.collection("comment").doc(article.id).get(),
      ]),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Object?>>
            snapshot, // Update the type of the snapshot parameter
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
          ); // Show error if there is any
        } else {
          dynamic favoriteData = (snapshot.data![0] as DocumentSnapshot).data();
          dynamic historyData = (snapshot.data![1] as DocumentSnapshot).data();
          dynamic commentData = (snapshot.data![2] as DocumentSnapshot);
          final commentExists = commentData.exists;
          if (!commentExists) {
            FirebaseFirestore.instance
                .collection("comment")
                .doc(article.id)
                .set(
              {
                "article": FirebaseFirestore.instance
                    .collection("article")
                    .doc(article.id),
                "comments": {
                  {
                    "content": "",
                    "datePost": Timestamp.now(),
                    "user": FirebaseFirestore.instance
                        .collection("user")
                        .doc(Auth().currentUser?.uid),
                  }
                }
              },
            ); // Replace with your initial comment data structure
          }
          final articlesFavorite = favoriteData["articles"];
          final articlesHistory = historyData["articles"];
          final commentUser = commentData.data();
          return _articleView(
            favorite: articlesFavorite,
            history: articlesHistory,
            article: article,
            comment: commentUser,
            controller: controller,
          );
        }
      },
    );
  }
}

class _articleView extends StatelessWidget {
  _articleView({
    super.key,
    required this.history,
    required this.favorite,
    required this.article,
    required this.controller,
    required this.comment,
  });

  var history;
  var favorite;
  var article;
  var comment;
  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showConfirmationBottomSheet(context, history, favorite, article);
            },
            icon: Icon(Icons.bookmark_add_outlined),
          ),
          IconButton(
              icon: Icon(Icons.comment_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      comment: comment,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: article is Article
          ? WebView(
              initialUrl: article.url,
              onWebViewCreated: (WebViewController webViewController) {
                controller.complete(webViewController);
              },
            )
          : WebView(
              initialUrl: article["url"],
              onWebViewCreated: (WebViewController webViewController) {
                controller.complete(webViewController);
              },
            ),
    );
  }
}

void showConfirmationBottomSheet(
  BuildContext context,
  dynamic history,
  dynamic favorite,
  Article article,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Do you want to add this article to favorites?",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Add article to favorites
                    final favoriteRef = FirebaseFirestore.instance
                        .collection("readLater")
                        .doc(Auth().currentUser?.uid);
                    final articleExistence = favorite[0]["article"];
                    if (articleExistence == "") {
                      favoriteRef.update({
                        "articles": ([
                          {
                            "article": FirebaseFirestore.instance
                                .collection("article")
                                .doc(article.id!),
                            "dateRead": Timestamp.now(),
                          }
                        ]),
                      });
                    } else {
                      List<dynamic> existingArticleIds = favorite
                          .map((article) => article["article"].id)
                          .toList();

                      // Check if the article exists
                      if (!existingArticleIds.contains(article.id)) {
                        // If the article doesn't exist, update the articles field
                        await favoriteRef.update({
                          "articles": FieldValue.arrayUnion([
                            {
                              "article": FirebaseFirestore.instance
                                  .collection("article")
                                  .doc(article.id!),
                              "dateRead": Timestamp.now(),
                            }
                          ]),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Article added to favorites!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        // If the article already exists, show a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "This article is already in your favorites list!",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
