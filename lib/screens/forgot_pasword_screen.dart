import 'package:flutter/material.dart';
import 'package:news_reader/screens/login_screen.dart';
import 'package:news_reader/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .background,
      appBar: AppBar(
        title: Text('Forgot Password?',
            style: Provider.of<ThemeProvider>(context)
                .getThemeData(context)
                .textTheme
                .displayMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: Text(
                'Fill in your registered email. If the email is valid, you will receive reset password instruction via email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                fillColor: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .brightness ==
                        Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade800,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 0),
              ),
              child: Text(
                'Reset Password',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
