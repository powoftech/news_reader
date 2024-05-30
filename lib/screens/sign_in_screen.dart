
import "package:cloud_firestore/cloud_firestore.dart";
import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/screens/forgot_password_screen.dart";
import "package:news_reader/screens/sign_up_screen.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class SignInScreen extends StatefulWidget {
  static const routeName = "/signin";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final TextEditingController _controllerEmailUsername =
      TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword(
    String emailOrUsername,
    String password,
  ) async {
    String email = "";

    try {
      if (EmailValidator.validate(emailOrUsername)) {
        email = emailOrUsername;
      } else {
        final users = FirebaseFirestore.instance.collection("user");
        final querySnapshot = await users
            .where(
              "username",
              isEqualTo: emailOrUsername,
            )
            .get();
        final documents = querySnapshot.docs;

        if (documents.isNotEmpty) {
          email = documents[0].data()["email"];
        } else {
          throw Exception("No email found with this username");
        }
      }

      await Auth().signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.red,
      ),);
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().split(":")[1]),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider().getThemeData(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;

    const String assetName = "assets/icon/play_store_512.svg";

    final Widget svgIcon = SvgPicture.asset(assetName,
        colorFilter: ColorFilter.mode(
          isDarkMode ? Colors.white : Colors.black,
          BlendMode.srcIn,
        ),
        semanticsLabel: "A red up arrow",);

    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      appBar: AppBar(
        leading: svgIcon,
        title: Text(
          "Welcome back",
          style: Provider.of<ThemeProvider>(context)
              .getThemeData(context)
              .textTheme
              .displayLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _controllerEmailUsername,
                  validator: (value) => (value!.isEmpty)
                      ? "Please enter your email address or username"
                      : null,
                  decoration: InputDecoration(
                    hintText: "Email or username",
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
                SizedBox(height: 10),
                TextFormField(
                  controller: _controllerPassword,
                  validator: (value) =>
                      (value!.isEmpty) ? "Please enter your password" : null,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Provider.of<ThemeProvider>(context)
                                .getThemeData(context)
                                .colorScheme
                                .brightness ==
                            Brightness.light
                        ? Colors.grey.shade200
                        : Colors.grey.shade800,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: _obscureText,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
                        signInWithEmailAndPassword(
                          _controllerEmailUsername.text,
                          _controllerPassword.text,
                        ),
                      },
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                      ), // Add the icon
                      SizedBox(width: 8),
                      Text(
                        "Sign in",
                        style: Provider.of<ThemeProvider>(context)
                            .getThemeData(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Text(
                    "No account? Get one here",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Text(
                    "Forgot your password?",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
