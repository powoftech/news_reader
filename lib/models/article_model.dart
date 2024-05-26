// This file contains the model class for the article

class Article {
  String? id;
  String? author;
  String? title;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? view;

  Article({
    required this.id,
    required this.author,
    required this.title,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.view,
  });
}
