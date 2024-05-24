import 'package:flutter/material.dart';
import 'package:news_reader/screens/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static const routeName = '/setting';

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int selectedButtonIndex = 1; // Default index of the selected button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
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
                            : Theme.of(context).brightness == Brightness.light
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
                        'English',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: selectedButtonIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Container(
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
                            : Theme.of(context).brightness == Brightness.light
                                ? Colors.grey.withAlpha(
                                    70) // Unselected button color in light mode
                                : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Tiếng Việt',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: selectedButtonIndex == 0
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _LogoutSettingButton(),
            SizedBox(height: 20),
            Text(
              'Phiên bản ứng dụng :1.0.57',
            ),
            SizedBox(height: 10),
            Text(
              'Bạn đã mở app này 2 lần',
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      surfaceTintColor: Colors.white,
                      title: Text('Confirmation'),
                      content:
                          Text('Are you sure you want to delete your account?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
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
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
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
                'Xóa tài khoản của tôi',
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

class _LogoutSettingButton extends StatelessWidget {
  const _LogoutSettingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white, // Set the button background color
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
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
            ), // Add the icon
            SizedBox(width: 8), // Add some spacing between icon and text
            Text(
              'Logout', // Add the text
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
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
