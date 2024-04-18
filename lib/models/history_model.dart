import 'package:news_reader/models/article_model.dart';

class HistoryModel {
  String? id;
  List<Article>? articles;
  HistoryModel({
    required this.id,
    required this.articles,
  });
}
