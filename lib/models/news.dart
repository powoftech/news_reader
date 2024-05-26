import "dart:convert";
import "package:news_reader/models/article_model.dart";
import "package:http/http.dart" as http;

class News {
  List<Article> news = [];
  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?apiKey=f1aa278709c9401babd856f6c1a4560c&country=us&category=technology";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          Article article = Article(
            id: element["id"],
            title: element["title"],
            author: element["author"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            publishedAt: element["publishedAt"],
            content: element["content"],
          );
          news.add(article);
        }
      });
    }
  }
}
