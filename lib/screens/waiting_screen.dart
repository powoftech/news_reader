import "package:flutter/material.dart";

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 128.0,
                width: 128.0,
                child: CircularProgressIndicator(
                  // color: isDarkMode ? Colors.white : Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? Colors.white : Colors.black),
                  strokeWidth: 8.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}