import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/widgets/theme_provider.dart";
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

void handleDeleteArticle(Article article, BuildContext context) {
  if (Provider.of<DeleteMode>(context, listen: false).isDeleteModeActive) {
    // Call your deleteArticleFromFirebase function here
    deleteArticlesFromFirebase(article.id!);
  }
}

Future<void> deleteArticlesFromFirebase(String articleId) async {
  final batch = FirebaseFirestore.instance.batch();
  final docRef =
      FirebaseFirestore.instance.collection("articles").doc(articleId);
  batch.delete(docRef);
  await batch.commit();
}

Article getArticleById(dynamic articles, String id) {
  return articles.firstWhere((article) => article.id == id);
}
