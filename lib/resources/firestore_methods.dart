import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";

/// A class that contains methods for interacting with Firestore.
class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates the view count of an article and adds it to the user's history.
  ///
  /// This method takes in the [articleId] and [userId] as parameters and updates the view count of the article
  /// with the given [articleId] in the Firestore database. It also adds the article to the user's history,
  /// with the current timestamp as the date read.
  ///
  /// Returns a [Future] that completes with a [String] indicating the result of the operation. If the operation
  /// is successful, the result will be "Success". If an error occurs, the result will be the error message.
  Future<String> viewArticle(String articleId, String userId) async {
    String result = "Error";

    try {
      DocumentReference articleRef = _firestore.collection("article").doc(articleId);

      await articleRef.update({
        "view": FieldValue.increment(1),
      });

      DocumentSnapshot historyDoc = await _firestore.collection("history").doc(userId).get();

      if (historyDoc.exists) {
        List<dynamic> articles = (historyDoc.data() as dynamic)["articles"];

        for (Map<String, dynamic> article in articles) {
          if (article["article"] == articleRef) {
            articles.remove(article);
            break;
          }
        }

        articles.insert(0, {
          "article": articleRef,
          "dateRead": Timestamp.now(),
        });

        _firestore.collection("history").doc(userId).update(
          {
            "articles": articles,
          },
        );
        result = "Success";
      } else {}
    } catch (error) {
      return error.toString();
    }

    return result;
  }

  /// Removes an article from the user's history.
  ///
  /// This method takes in the [articleId] and [userId] as parameters and removes the corresponding article from the user's history in Firestore.
  /// It returns a [Future] that resolves to a [String] indicating the result of the operation, either "Success" or "Error".
  /// If an error occurs during the process, the error message is returned as a [String].
  Future<String> removeArticleHistory(String articleId, String userId) async {
    String result = "Error";

    try {
      DocumentReference articleRef = _firestore.collection("article").doc(articleId);

      DocumentSnapshot history = await _firestore.collection("history").doc(userId).get();

      if (history.exists) {
        bool removed = false;
        List<dynamic> articles = (history.data() as dynamic)["articles"];

        for (Map<String, dynamic> article in articles) {
          if (article["article"] == articleRef) {
            articles.remove(article);
            removed = true;
            log("Okay");
            break;
          }
        }

        if (removed) {
          await _firestore.collection("history").doc(userId).update({
            "articles": articles,
          });
        }

        result = "Success";
      } else {}
    } catch (error) {
      return error.toString();
    }

    return result;
  }

  /// Checks if an article is in the "Read Later" list for a specific user.
  ///
  /// Returns `true` if the article is in the "Read Later" list, `false` otherwise.
  /// Throws an error if there is an issue with the Firestore operation.
  Future<bool> isArticleInReadLater(String articleId, String userId) async {
    bool result = false;

    try {
      DocumentReference articleRef =
          _firestore.collection("article").doc(articleId);

      DocumentSnapshot readLater =
          await _firestore.collection("readLater").doc(userId).get();

      if (readLater.exists) {
        List<dynamic> articles = (readLater.data() as dynamic)["articles"];

        for (Map<String, dynamic> article in articles) {
          if (article["article"] == articleRef) {
            result = true;
            break;
          }
        }
      } else {
        log("Error");
      }
    } catch (error) {
      log(error.toString());
    }

    return result;
  }

  /// Reads an article and adds it to the user's read later list.
  ///
  /// This method takes in the [articleId] and [userId] as parameters and returns a [Future] of type [String].
  /// It retrieves the article from Firestore using the [articleId] and checks if the user's read later list exists.
  /// If the list exists, it checks if the article is already in the list. If it is, it removes it from the list.
  /// If the article is not in the list, it adds it to the beginning of the list with the current timestamp.
  /// Finally, it updates the user's read later list in Firestore and returns a result of "Success" or "Error".
  ///
  /// Throws an error if any exception occurs during the process.
  Future<String> readLaterArticle(String articleId, String userId) async {
    String result = "Error";

    try {
      DocumentReference articleRef = _firestore.collection("article").doc(articleId);

      DocumentSnapshot readLater = await _firestore.collection("readLater").doc(userId).get();

      if (readLater.exists) {
        bool removed = false;
        List<dynamic> articles = (readLater.data() as dynamic)["articles"];

        for (Map<String, dynamic> article in articles) {
          if (article["article"] == articleRef) {
            articles.remove(article);
            removed = true;
            break;
          }
        }

        if (removed) {
        } else {
          articles.insert(0, {
            "article": _firestore.collection("article").doc(articleId),
            "dateAdded": Timestamp.now(),
          });
        }

        _firestore.collection("readLater").doc(userId).update({
          "articles": articles,
        });

        result = "Success";
      } else {}
    } catch (error) {
      return error.toString();
    }

    return result;
  }

  /// Posts a comment on an article.
  ///
  /// Returns a [Future] that completes with a [String] indicating the result of the operation.
  /// The possible results are "Success" if the comment is posted successfully, or "Error" if an error occurs.
  ///
  /// The [articleId] parameter is the ID of the article on which the comment is being posted.
  /// The [userId] parameter is the ID of the user posting the comment.
  /// The [content] parameter is the content of the comment.
  ///
  /// Throws an error if any error occurs during the operation.
  Future<String> postComment(
    String articleId,
    String userId,
    String content,
  ) async {
    String result = "Error";

    try {
      DocumentReference docRef =
          _firestore.collection("comment").doc(articleId);
      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        await docRef.update(
          {
            "comments": FieldValue.arrayUnion([
              {
                "user": _firestore.collection("user").doc(userId),
                "content": content,
                "datePost": Timestamp.now(),
              }
            ]),
          },
        );
      } else {
        await docRef.set(
          {
            "article": _firestore.collection("article").doc(articleId),
            "comments": [
              {
                "user": _firestore.collection("user").doc(userId),
                "content": content,
                "datePost": Timestamp.now(),
                // "lastEdited": Timestamp.now(),
              },
            ],
          },
        );
      }

      result = "Success";
    } catch (error) {
      return error.toString();
    }

    return result;
  }
}
