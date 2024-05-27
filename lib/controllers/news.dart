import "package:cloud_firestore/cloud_firestore.dart";
import "package:news_reader/controllers/date_formatter.dart";
import "package:news_reader/models/article_model.dart";

class News {
  List<Article> news = [];
  final firestore = FirebaseFirestore.instance;
  final dateFormatter = DateFormatter();
  final allTopics = <String>{};
  Future<void> getNews() async {
    final collectionRef = firestore
        .collection("article")
        .orderBy("datePublished", descending: true)
        .limit(50);
    final querySnapshot = await collectionRef.get();

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
      );
      // Add article to the list
      news.add(article);
      final articleTopics = data["topic"] as List<dynamic>;
      allTopics.addAll(articleTopics.expand((topic) => [topic]));
    }
  }
}
