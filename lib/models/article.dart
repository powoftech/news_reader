import "package:cloud_firestore/cloud_firestore.dart";

/// Represents an article in the news reader application.
class Article {
  List<String> author;
  Timestamp datePublished;
  String image;
  String title;
  List<String> topic;
  String url;
  int view;

  // bool isDeleteModeActive = false;

  Article({
    required this.author,
    required this.datePublished,
    required this.image,
    required this.title,
    required this.topic,
    required this.url,
    required this.view,
  });

  static Article fromSnap(DocumentSnapshot snap) {
    var snapData = snap.data() as Map<String, dynamic>;

    return Article(
      author: snapData["author"],
      title: snapData["title"],
      url: snapData["url"],
      image: snapData["image"],
      datePublished: snapData["datePublished"],
      view: snapData["view"],
      topic: snapData["topic"],
    );
  }

  Map<String, dynamic> toJson() => {
        "author": author,
        "title": title,
        "url": url,
        "image": image,
        "datePublished": datePublished,
        "view": view,
        "topic": topic,
      };
}
