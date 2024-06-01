import "package:cloud_firestore/cloud_firestore.dart";

/// Represents a user in the system.
class User {
  Timestamp dateCreated;
  String email;
  Timestamp lastActive;
  DocumentReference status;
  DocumentReference type;
  String username;

  User({
    required this.dateCreated,
    required this.email,
    required this.lastActive,
    required this.status,
    required this.type,
    required this.username,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapData = snap.data() as Map<String, dynamic>;

    return User(
      dateCreated: snapData["dateCreated"],
      email: snapData["email"],
      lastActive: snapData["lastActive"],
      status: snapData["status"],
      type: snapData["type"],
      username: snapData["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "dateCreated": dateCreated,
        "email": email,
        "lastActive": lastActive,
        "status": status,
        "type": type,
        "username": username,
      };
}
