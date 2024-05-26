import "package:flutter/material.dart";
import "package:news_reader/auth.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static const routeName = "/setting";

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int selectedButtonIndex = 0; // Default index of the selected button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Language",
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .displayLarge,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndex =
                              0; // Update the selected button index
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedButtonIndex == 0
                            ? Colors.blue.shade300
                            : Provider.of<ThemeProvider>(context)
                                        .getThemeData(context)
                                        .brightness ==
                                    Brightness.light
                                ? Colors.grey.withAlpha(
                                    70) // Unselected button color in light mode
                                : Colors
                                    .white, // Unselected button color in dark mode
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "English",
                        style: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                              color: selectedButtonIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndex =
                              1; // Update the selected button index
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedButtonIndex == 1
                            ? Colors.blue.shade300
                            : Provider.of<ThemeProvider>(context)
                                        .getThemeData(context)
                                        .brightness ==
                                    Brightness.light
                                ? Colors.grey.withAlpha(
                                    70) // Unselected button color in light mode
                                : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Vietnamese",
                        style: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                              color: selectedButtonIndex == 0
                                  ? Colors.black
                                  : Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _SignOutSettingsButton(),
            SizedBox(height: 20),
            Text(
              "App version: 1.0.0",
            ),
            SizedBox(height: 10),
            // Text(
            //   'Bạn đã mở app này 2 lần',
            // ),
            // SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      surfaceTintColor: Colors.white,
                      title: Text("Confirmation"),
                      content:
                          Text("Are you sure you want to delete your account?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Provider.of<ThemeProvider>(context)
                                          .getThemeData(context)
                                          .brightness ==
                                      Brightness.light
                                  ? Colors
                                      .black // Unselected button color in light mode
                                  : Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Perform the action to delete the account
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Provider.of<ThemeProvider>(context)
                                          .getThemeData(context)
                                          .brightness ==
                                      Brightness.light
                                  ? Colors
                                      .black // Unselected button color in light mode
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Delete my account",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignOutSettingsButton extends StatelessWidget {
  const _SignOutSettingsButton();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: signOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .brightness ==
                  Brightness.light
              ? Colors.black
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .brightness ==
                      Brightness.light
                  ? Colors.white
                  : Colors.black,
            ), // Add the icon
            SizedBox(width: 8), // Add some spacing between icon and text
            Text(
              "Sign out", // Add the text
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(
                    color: Provider.of<ThemeProvider>(context)
                                .getThemeData(context)
                                .brightness ==
                            Brightness.light
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
