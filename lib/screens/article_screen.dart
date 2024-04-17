import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key, required this.article});
  final Article article;
  static const routeName = '/article';

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> controller =
        Completer<WebViewController>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
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
