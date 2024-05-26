import "package:html/parser.dart";
import "package:news_reader/models/article_model.dart";
import "package:http/http.dart" as http;
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:intl/intl.dart';
import "package:news_reader/widgets/date_formatter.dart";

DateTime? parseFirestoreDateTime(String dateString) {
  try {
    // Try parsing with format including day of week and month name
    final format1 = DateFormat("E, dd MMM yyyy HH:mm:ss Z");
    return format1.parse(dateString);
  } on FormatException {
    // If parsing fails, try with format excluding day of week and month name
    try {
      final format2 = DateFormat("yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'");
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
  Future<void> getNews() async {
    final collectionRef = firestore.collection("article");
    final querySnapshot = await collectionRef.get();
    querySnapshot.docs.forEach((doc) {
      // Convert each document to a Map
      Map<String, dynamic> data = doc.data();
      DateTime? dateTime = parseFirestoreDateTime(data["datePublished"]);
      String formattedDate = dateFormatter.formattedDate(dateTime!);
      // Create Article object
      Article article = Article(
        id: doc.id,
        title: data["title"],
        author: "John Smith",
        url: data["url"],
        urlToImage:
            "https://media.istockphoto.com/id/1313654813/vector/megaphone-with-exciting-news-speech-bubble-banner-loudspeaker-label-for-business-marketing.jpg?s=612x612&w=0&k=20&c=0Gm0WhT6uMnzhvElm3OB5hu8_Dsn5SvfXfkMNuA_UAw=",
        publishedAt: formattedDate,
        view: data["view"].toString(),
      );
      // Add article to the list
      news.add(article);
    });
  }
}
