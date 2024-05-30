import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

Future<void> updateFieldInFirebase(
  String entity,
  String documentId,
  String fieldName,
  dynamic newValue,
) async {
  try {
    final docRef =
        FirebaseFirestore.instance.collection(entity).doc(documentId);
    await docRef.update({
      fieldName: newValue, // Specify the field name and new value
    });
    print(
        "Successfully updated field: $fieldName in document: $documentId"); // Optional success message
  } on FirebaseException catch (e) {
    print("Error updating field: $e"); // Handle potential errors
  }
}

void handleDeleteArticle(BuildContext context, String field, dynamic history,
    dynamic favorite, int index) async {
  if (Provider.of<DeleteModeProvider>(context, listen: false)
      .isDeleteModeActive) {
    // Call your deleteArticleFromFirebase function here
    deleteArticlesFromFirebase(field, history, favorite, index);
  }
}

Future<void> deleteArticlesFromFirebase(
  String field,
  dynamic history,
  dynamic favorite,
  int index,
) async {
  final uid = Auth().currentUser?.uid;
  if (field == "favorite") {
    final favoriteRef =
        FirebaseFirestore.instance.collection("readLater").doc(uid);
    favoriteRef.update({
      "articles": FieldValue.arrayRemove([favorite[index]]),
    });
    if (index == 0 && favorite.length == 1) {
      favoriteRef.update({
        "articles": ([
          {
            "article": "",
            "dateRead": Timestamp.now(),
          }
        ]),
      });
    }
  } else {
    final historyRef =
        FirebaseFirestore.instance.collection("history").doc(uid);
    historyRef.update({
      "articles": FieldValue.arrayRemove([history[index]]),
    });
    if (index == 0 && history.length == 1) {
      historyRef.update({
        "articles": ([
          {
            "article": "",
            "dateRead": Timestamp.now(),
          }
        ]),
      });
    }
  }
}

dynamic getArticleById(dynamic articles, String id) {
  return articles.firstWhere((article) => article.id == id);
}
