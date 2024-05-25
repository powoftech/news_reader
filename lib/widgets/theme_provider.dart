import 'package:flutter/material.dart';

abstract class DataProvider {}

// Theme Data Provider (Concrete Class)
class ThemeProvider extends ChangeNotifier implements DataProvider {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData getThemeData(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return _lightTheme;
      case ThemeMode.dark:
        return _darkTheme;
      default:
        return _lightTheme;
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // Notify listeners about the change
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
