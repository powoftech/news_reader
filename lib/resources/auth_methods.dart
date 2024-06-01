import "package:cloud_firestore/cloud_firestore.dart";
import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:news_reader/models/read_later.dart" as model;
import "package:news_reader/models/user.dart" as model;
import "package:news_reader/models/history.dart" as model;

/// This class provides methods for authentication.
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User get currentUser => _auth.currentUser!;

  /// Retrieves the user information from the Firestore database.
  ///
  /// This method fetches the current user's information from the Firestore
  /// collection "user" based on their unique user ID. It returns a [model.User]
  /// object representing the user's data.
  ///
  /// Returns:
  ///   A [Future] that completes with a [model.User] object representing the
  ///   user's data.
  Future<model.User> getUser() async {
    User? currentUser = _auth.currentUser;

    DocumentSnapshot snap =
        await _firestore.collection("user").doc(currentUser?.uid).get();

    return model.User.fromSnap(snap);
  }

  /// Signs up a new user with the provided email, username, and password.
  ///
  /// Returns a [Future] that completes with a [String] indicating the result of the sign-up process.
  /// Possible results are:
  /// - "Success" if the sign-up is successful.
  /// - "Error" if there is an error during the sign-up process.
  /// - "Missing fields" if any of the required fields (email, username, password) are empty.
  ///
  /// Throws an [Exception] if the provided username is already in use by another account.
  /// Throws a [FirebaseAuthException] if there is an error with the Firebase authentication service.
  Future<String> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    String result = "Error";
    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        QuerySnapshot existUserSnap = await _firestore
            .collection("user")
            .where(
              "username",
              isEqualTo: username,
            )
            .get();

        if (existUserSnap.docs.isNotEmpty) {
          throw Exception("The username is already in use by another account");
        }

        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection("user").doc(userCred.user!.uid).set(
              model.User(
                dateCreated: Timestamp.now(),
                email: email,
                username: username,
                lastActive: Timestamp.now(),
                type: _firestore.collection("userType").doc("reader"),
                status: _firestore.collection("userStatus").doc("active"),
              ).toJson(),
            );

        await _firestore.collection("history").doc(userCred.user!.uid).set(
              model.History(
                user: _firestore.collection("user").doc(userCred.user!.uid),
                articles: [],
              ).toJson(),
            );

        await _firestore.collection("readLater").doc(userCred.user!.uid).set(
              model.ReadLater(
                user: _firestore.collection("user").doc(userCred.user!.uid),
                articles: [],
              ).toJson(),
            );

        result = "Success";
      } else {
        result = "Missing fields";
      }
    } on FirebaseAuthException catch (error) {
      return error.toString();
    } on Exception catch (error) {
      return error.toString();
    }
    return result;
  }

  /// Signs in the user with the provided email or username and password.
  ///
  /// Returns a [Future] that completes with a [String] indicating the result of the sign-in process.
  /// Possible results are:
  /// - "Success" if the sign-in is successful.
  /// - "Error" if an error occurs during the sign-in process.
  /// - "Missing fields" if either the email/username or password is empty.
  /// - The error message if an [FirebaseAuthException] or [Exception] is thrown during the sign-in process.
  Future<String> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    String result = "Error";
    try {
      if (emailOrUsername.isNotEmpty && password.isNotEmpty) {
        String email = "";

        if (EmailValidator.validate(emailOrUsername)) {
          email = emailOrUsername;
        } else {
          QuerySnapshot userSnap = await _firestore
              .collection("user")
              .where(
                "username",
                isEqualTo: emailOrUsername,
              )
              .get();

          if (userSnap.docs.isNotEmpty) {
            email = (userSnap.docs[0].data() as Map<String, dynamic>)["email"];
          } else {
            throw Exception("No email found with this username");
          }
        }

        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        result = "Success";
      } else {
        result = "Missing fields";
      }
    } on FirebaseAuthException catch (error) {
      return error.toString();
    } on Exception catch (error) {
      return error.toString();
    }
    return result;
  }

  /// Signs out the user.
  ///
  /// This method signs out the currently authenticated user.
  /// It uses the [_auth] instance to perform the sign out operation.
  /// 
  /// Example usage:
  /// ```dart
  /// AuthMethods authMethods = AuthMethods();
  /// await authMethods.signOut();
  /// ```
  Future<void> signOut() async {
    await _auth.signOut();
  }

}
