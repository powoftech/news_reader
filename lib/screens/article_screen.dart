import "dart:async";
import "package:flutter/material.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/models/favorite_model.dart";
import "package:news_reader/models/history_model.dart";
import "package:webview_flutter/webview_flutter.dart";

class ArticleScreen extends StatelessWidget {
  const ArticleScreen(
      {super.key,
      required this.article,
      required this.favorite,
      required this.history});
  final Article article;
  final Favorite favorite;
  final HistoryModel history;
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

void showConfirmationBottomSheet(BuildContext context, HistoryModel history,
    Favorite favorite, Article article) {
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
                  onPressed: () {
                    // Add article to favorites
                    favorite.articles?.add(article);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Article added to favorites!"),
                        duration: Duration(seconds: 2),
                      ),
                    );
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
