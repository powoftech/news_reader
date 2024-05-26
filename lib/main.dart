import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:news_reader/widget_tree.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

import "firebase_options.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      // Wrap MyApp with ChangeNotifierProvider
      create: (context) =>
          ThemeProvider(), // Provide an instance of ThemeProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getThemeData(context),
      home: WidgetTree(),
      debugShowCheckedModeBanner: false,
    );
  }
}


