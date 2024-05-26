import "package:news_reader/models/article_model.dart";

class Favorite {
  String? id;
  List<Article>? articles;
  Favorite({
    required this.id,
    required this.articles,
  });
}
