import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/screens/sign_in_screen.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedButtonIndex = 0; // Default index of the selected button
  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerDisplayFirstName =
      TextEditingController();
  final TextEditingController _controllerDisplayLastName =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerDisplayName.value = TextEditingValue(
      text: "",
    );
    _controllerDisplayFirstName.value = TextEditingValue(
      text: "User first name",
    );
    _controllerDisplayLastName.value = TextEditingValue(
      text: "User last name",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Preferences",
          style: Provider.of<ThemeProvider>(context)
              .getThemeData(context)
              .textTheme
              .displayLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 110),
              Text(
                "Display name",
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleSmall,
              ),
              TextFormField(
                controller: _controllerDisplayName,
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleMedium,
                decoration: InputDecoration(
                  hintText: "User name",
                  filled: true,
                  fillColor: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .colorScheme
                              .brightness ==
                          Brightness.light
                      ? Colors.grey.shade200
                      : Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "First name",
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleSmall,
              ),
              TextFormField(
                controller: _controllerDisplayFirstName,
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleMedium,
                decoration: InputDecoration(
                  hintText: "User first name",
                  filled: true,
                  fillColor: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .colorScheme
                              .brightness ==
                          Brightness.light
                      ? Colors.grey.shade200
                      : Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Last name",
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleSmall,
              ),
              TextFormField(
                controller: _controllerDisplayLastName,
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleMedium,
                decoration: InputDecoration(
                  hintText: "User last name",
                  filled: true,
                  fillColor: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .colorScheme
                              .brightness ==
                          Brightness.light
                      ? Colors.grey.shade200
                      : Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select language",
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleSmall,
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
                                      70,
                                    ) // Unselected button color in light mode
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
                              .titleMedium!
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
                                      70,
                                    ) // Unselected button color in light mode
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
                              .titleMedium!
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
              SizedBox(height: 40),
              _SaveProfileButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveProfileButton extends StatelessWidget {
  const _SaveProfileButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        },
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
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "Save", // Add the text
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
        ),
      ),
    );
  }
}
