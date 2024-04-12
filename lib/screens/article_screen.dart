import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key});

  static const routeName = '/article';

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)!.settings.arguments as Article;
    final Completer<WebViewController> controller =
        Completer<WebViewController>();

    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: article.url,
        onWebViewCreated: (WebViewController webViewController) {
          controller.complete(webViewController);
        },
      ),
    );
  }
}
