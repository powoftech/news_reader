import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

class SettingScreenUser extends StatefulWidget {
  const SettingScreenUser({super.key});

  static const routeName = "/setting_user";

  @override
  State<SettingScreenUser> createState() => _SettingScreenUserState();
}

class _SettingScreenUserState extends State<SettingScreenUser> {
  int selectedButtonIndex = 0; // Default index of the selected button
  // late Map<String, dynamic>? user;

  late Future<Map<String, dynamic>?> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = fetchUser();
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<Map<String, dynamic>?> fetchUser() async {
    final uid = Auth().currentUser?.uid;

    final userDoc = FirebaseFirestore.instance.collection("user").doc(uid);
    final snapshot = await userDoc.get();
    final user = snapshot.data();
    return user;
  }

  // Future<void> initializeDocument() async {
  //   final uid = Auth().currentUser?.uid;

  //   final userDoc = FirebaseFirestore.instance.collection("user").doc(uid);
  //   final snapshot = await userDoc.get();
  //   user = snapshot.data();
  //   inspect(user);
  // }

  SizedBox signOutButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: signOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
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
              color: Colors.white,
            ), // Add the icon
            SizedBox(width: 8), // Add some spacing between icon and text
            Text(
              "Sign out", // Add the text
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder headPart(BuildContext context) {
    return FutureBuilder(
      future: userFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
          ); // Show error message if any error occurs
        } else {
          var user = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                user["username"],
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .displayMedium,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user["email"],
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .titleLarge,
              ),
              Divider(
                color: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .colorScheme
                            .brightness ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Profile",
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.bookmark_outline),
                    SizedBox(width: 5),
                    Text(
                      "Bookmark",
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .colorScheme
                            .brightness ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 5),
                    Text(
                      "Settings",
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
            ],
          );
        }
      },
    );
  }

  Row languageChange(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedButtonIndex = 0; // Update the selected button index
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
                        : Colors.white, // Unselected button color in dark mode
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
                  selectedButtonIndex = 1; // Update the selected button index
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
    );
  }

  GestureDetector info(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: Text("Confirmation"),
              content: Text("Are you sure you want to delete your account?"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              headPart(context),
              languageChange(context),
              SizedBox(height: 20),
              Text(
                "App version: 1.0.0",
              ),
              SizedBox(height: 10),
              // Text(
              //   'Bạn đã mở app này 2 lần',
              // ),
              // SizedBox(height: 20),
              info(context),
              SizedBox(height: 40),
              signOutButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
