import "package:flutter/material.dart";
import "package:news_reader/screens/change_password_screen.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class SettingScreenUserSettings extends StatelessWidget {
  static const routeName = "/user_settings";
  const SettingScreenUserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      appBar: AppBar(
        title: Text("Settings",
            style: Provider.of<ThemeProvider>(context)
                .getThemeData(context)
                .textTheme
                .displayLarge,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),),),
              child: Row(
                children: [
                  Icon(Icons.password_outlined),
                  SizedBox(width: 10),
                  Text(
                    "Change password",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .titleLarge,
                  ),
                ],
              ),
            ),
            Divider(
                color: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .colorScheme
                            .brightness ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white,),
          ],
        ),
      ),
    );
  }
}
