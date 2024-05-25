import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Auth._constructor();

  static final Auth _instance = Auth._constructor();

  factory Auth() => _instance;

  User? get currentUser => _instance.currentUser;
  Stream<User?> get authStateChanges => _instance.authStateChanges;

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _instance.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _instance.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await _instance.logout();
  }
}
