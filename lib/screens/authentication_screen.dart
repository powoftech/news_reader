import "package:flutter/material.dart";
import "package:news_reader/screens/sign_in_screen.dart";

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = ThemeProvider().getThemeData(context);
    // bool isDarkMode = themeData.brightness == Brightness.dark;

    return SignInScreen(email: "");
  }
}
