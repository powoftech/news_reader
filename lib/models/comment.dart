import "package:cloud_firestore/cloud_firestore.dart";

/// Represents a comment on a news article.
class Comment {
  DocumentReference article;
  List<Map<String, dynamic>> comments;

  Comment({
    required this.article,
    required this.comments,
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapData = snap.data() as Map<String, dynamic>;

    return Comment(
      article: snapData["article"],
      comments: snapData["comments"],
    );
  }

  Map<String, dynamic> toJson() => {
        "article": article,
        "comments": comments,
      };
}
