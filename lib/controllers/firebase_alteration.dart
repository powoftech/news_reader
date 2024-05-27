import "package:cloud_firestore/cloud_firestore.dart";
import "package:news_reader/models/article_model.dart";

Future<void> updateFieldInFirebase(String enitty, String documentId,
    String fieldName, dynamic newValue) async {
  try {
    final docRef =
        FirebaseFirestore.instance.collection(enitty).doc(documentId);
    await docRef.update({
      fieldName: newValue, // Specify the field name and new value
    });
    print(
        "Successfully updated field: $fieldName in document: $documentId"); // Optional success message
  } on FirebaseException catch (e) {
    print("Error updating field: $e"); // Handle potential errors
  }
}

Article getArticleById(List<Article> articles, String id) {
  return articles.firstWhere((article) => article.id == id);
}
