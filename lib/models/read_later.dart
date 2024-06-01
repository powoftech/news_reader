import "package:cloud_firestore/cloud_firestore.dart";

/// Represents an article that the user wants to read later.
class ReadLater {
  DocumentReference user;
  List<Map<String, dynamic>> articles;

  ReadLater({
    required this.user,
    required this.articles,
  });

  static ReadLater fromSnap(DocumentSnapshot snap) {
    var snapData = snap.data() as Map<String, dynamic>;

    return ReadLater(
      user: snapData["user"],
      articles: snapData["articles"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user,
        "articles": articles,
      };
}
