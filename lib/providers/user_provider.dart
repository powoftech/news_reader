
import "package:flutter/foundation.dart";
import "package:news_reader/models/user.dart";
import "package:news_reader/resources/auth_methods.dart";

/// A provider class for managing user data.
///
/// This class extends the [ChangeNotifier] class, allowing it to notify
/// listeners when the user data changes.
class UserProvider with ChangeNotifier {
  User? _user;

  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;
  
  Future<void> refreshUser() async {
    User user = await _authMethods.getUser();
    _user = user;
    notifyListeners();
  }
}
