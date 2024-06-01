import "package:cloud_firestore/cloud_firestore.dart";

/// Represents a history object.
class History {
  DocumentReference user;
  List<Map<String, dynamic>> articles;

  History({
    required this.user,
    required this.articles,
  });

  static History fromSnap(DocumentSnapshot snap) {
    var snapData = snap.data() as Map<String, dynamic>;

    return History(
      user: snapData["user"],
      articles: snapData["articles"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user,
        "articles": articles,
      };
}
