import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:news_reader/resources/auth_methods.dart";
import "package:news_reader/screens/app_screen.dart";
import "package:news_reader/utils/utils.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signup";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  void signUpUser() async {
    final navigator = Navigator.of(context);

    String result = await AuthMethods().signUp(
      email: _controllerEmail.text,
      username: _controllerUsername.text,
      password: _controllerPassword.text,
    );

    if (result == "Success") {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AppScreen()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      showSnackBar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    final Widget svgIcon = SvgPicture.asset(
      "assets/icon/play_store_512.svg",
      colorFilter: ColorFilter.mode(
        context.isDarkMode ? Colors.white : Colors.black,
        BlendMode.srcIn,
      ),
      height: 128,
      semanticsLabel: "",
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getThemeData(context)
            .colorScheme
            .surface,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isKeyboardShowing) svgIcon,
                if (!isKeyboardShowing) SizedBox(height: 40),
                TextFormField(
                  controller: _controllerEmail,
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "The email address is invalid.",
                  decoration: InputDecoration(
                    hintText: "Email",
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerUsername,
                  validator: (value) {
                    String pattern = r"^[a-zA-Z0-9_]+$";
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value!)) {
                      return "The username must contain only letters, digits, underscores.";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Username",
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
                  validator: (value) {
                    String error = """The password must contain at least""";

                    // if (!RegExp(r"[a-zA-z]").hasMatch(value!)) {
                    //   error += " 1 letter,";
                    // }
                    // if (!RegExp(r"[0-9]").hasMatch(value)) {
                    //   error += " 1 number,";
                    // }
                    if (value!.length < 10) {
                      error += " 10 characters.";
                    }

                    if (error == "The password must contain at least") {
                      return null;
                    } else {
                      return error;
                    }
                  },
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
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "By registering, you agree and acknowledge that you understand the privacy policy for this application.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      signUpUser();
                    }
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
                        "Sign up",
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
                    Navigator.pop(context);
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
                    "Already have an account?",
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
