

import "package:cloud_firestore/cloud_firestore.dart";

class UserModel {
  String? id;
  String? email;
  String? username;
  Timestamp? dateCreated;
  Timestamp? lastActive;
  String? status;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.dateCreated,
    required this.lastActive,
    required this.status,
  });
}
