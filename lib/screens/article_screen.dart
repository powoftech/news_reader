import "dart:async";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/models/article_model.dart";

import "package:webview_flutter/webview_flutter.dart";

class ArticleScreen extends StatelessWidget {
  const ArticleScreen(
      {super.key,
      required this.article,
      required this.favorite,
      required this.history});
  final Article article;
  final dynamic favorite;
  final dynamic history;
  static const routeName = "/article";

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> controller =
        Completer<WebViewController>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showConfirmationBottomSheet(context, history, favorite, article);
            },
            icon: Icon(
              Icons.bookmark_add_outlined, // Customize the icon as needed
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: article.url,
        onWebViewCreated: (WebViewController webViewController) {
          controller.complete(webViewController);
        },
      ),
    );
  }
}

void showConfirmationBottomSheet(
    BuildContext context, dynamic history, dynamic favorite, Article article) {
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
                    final favoriteData = await favorite.get();
                    final articleExistence =
                        favoriteData.data()!["articles"][0]["article"];
                    if (articleExistence == "") {
                      favorite.update({
                        "articles": ([
                          {
                            "article": FirebaseFirestore.instance
                                .collection("article")
                                .doc(article.id!),
                            "dateRead": Timestamp.now(),
                          }
                        ])
                      });
                    } else {
                      List<dynamic> existingArticleIds = favoriteData
                          .data()!["articles"]
                          .map((article) => article["article"].id)
                          .toList();

                      // Check if the article exists
                      if (!existingArticleIds.contains(article.id)) {
                        // If the article doesn't exist, update the articles field
                        favorite.update({
                          "articles": FieldValue.arrayUnion([
                            {
                              "article": FirebaseFirestore.instance
                                  .collection("article")
                                  .doc(article.id!),
                              "dateRead": Timestamp.now(),
                            }
                          ])
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
                                "This article is already in your favorites list!"),
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
