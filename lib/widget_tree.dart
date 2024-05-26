import "package:flutter/material.dart";
import "package:news_reader/auth.dart";
import "package:news_reader/screens/app_screen.dart";
import "package:news_reader/screens/authentication_screen.dart";

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const AppScreen();
        } else {
          return const AuthenticationScreen();
        }
      },
    );
  }
}
