import "package:news_reader/models/article_model.dart";

class History {
  String? id;
  List<Article>? articles;
  History({
    required this.id,
    required this.articles,
  });
}
