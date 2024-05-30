import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/controllers/date_formatter.dart";
import "package:news_reader/models/article_model.dart";

List<dynamic> uppercaseFirstLetters(List<dynamic> list) {
  final uppercaseList = <dynamic>[];
  for (var item in list) {
    uppercaseList.add(item[0].toUpperCase() + item.substring(1));
  }
  return uppercaseList;
}

class News {
  static List<Article> news = [];
  Set<String> allTopics = {};
  late DocumentReference<Map<String, dynamic>> favorite;
  late DocumentReference<Map<String, dynamic>> history;
  late Query<Map<String, dynamic>> article;
  Future<void> getNews() async {
    final uid = Auth().currentUser?.uid;
    log(uid!);
    final user = FirebaseFirestore.instance.collection("user").doc(uid);
    final userHistory =
        FirebaseFirestore.instance.collection("history").doc(uid);
    final userFavorite =
        FirebaseFirestore.instance.collection("readLater").doc(uid);

    userHistory.get().then((docSnapshot) async {
      if (!docSnapshot.exists) {
        await userHistory.set({
          "articles": {
            {
              "article": "",
              "dateRead": Timestamp.now(),
            },
          },
          "user": user,
        });
      }
    });
    userFavorite.get().then((docSnapshot) async {
      if (!docSnapshot.exists) {
        await userFavorite.set({
          "articles": {
            {
              "article": "",
              "dateRead": Timestamp.now(),
            },
          },
          "user": user,
        });
      }
    });

    final articleRef = FirebaseFirestore.instance
        .collection("article")
        .orderBy("datePublished", descending: true)
        .limit(50);
    final querySnapshot = await articleRef.get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      Timestamp datePublished = data["datePublished"];
      String publishedAt =
          DateFormatter().formattedDate(datePublished.toDate());

      String author = List<String>.from(data["author"])
          .map((item) => item.toString())
          .toList()
          .join(", ");

      // Create Article object
      Article article = Article(
        id: doc.id,
        title: data["title"],
        author: author,
        url: data["url"],
        urlToImage: data["image"],
        publishedAt: publishedAt,
        view: data["view"].toString(),
        topic: List<String>.from(data["topic"])
            .map((item) => item.toString())
            .toList(),
      );

      // Add article to the list
      news.add(article);
      final articleTopics =
          uppercaseFirstLetters(data["topic"] as List<dynamic>);
      allTopics.addAll(articleTopics.expand((topic) => [topic]));
    }
    favorite = userFavorite;
    history = userHistory;
    article = articleRef;
  }
}
