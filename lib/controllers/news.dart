import "package:cloud_firestore/cloud_firestore.dart";
import "package:intl/intl.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/controllers/date_formatter.dart";

DateTime? parseFirestoreDateTime(String dateString) {
  try {
    // Try parsing with format including day of week and month name
    final format1 = DateFormat("E, dd MMM yyyy HH:mm:ss Z");
    return format1.parse(dateString);
  } on FormatException {
    // If parsing fails, try with format excluding day of week and month name
    try {
      final format2 = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      return format2.parse(dateString);
    } on FormatException catch (e) {
      // Handle all other parsing exceptions
      print("Error parsing date string: $e");
      return null; // Or throw a custom exception
    }
  }
}

class News {
  List<Article> news = [];
  final firestore = FirebaseFirestore.instance;
  final dateFormatter = DateFormatter();
  final allTopics = <String>{};
  Future<void> getNews() async {
    final collectionRef = firestore.collection("article");
    final querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      // Convert each document to a Map
      Map<String, dynamic> data = doc.data();
      DateTime? dateTime = parseFirestoreDateTime(data["datePublished"]);
      String formattedDate = dateFormatter.formattedDate(dateTime!);
      // Create Article object
      Article article = Article(
        id: doc.id,
        title: data["title"],
        author: data["author"],
        url: data["url"],
        urlToImage: data["image"],
        publishedAt: formattedDate,
        view: data["view"].toString(),
      );
      // Add article to the list
      news.add(article);
      final articleTopics = data["topic"] as List<String>;
      allTopics.addAll(articleTopics.expand((topic) => [topic]));
    }
  }
}
