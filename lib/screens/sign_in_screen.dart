import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:news_reader/resources/auth_methods.dart";
import "package:news_reader/screens/app_screen.dart";
import "package:news_reader/screens/sign_up_screen.dart";
import "package:news_reader/utils/utils.dart";
import "package:news_reader/widgets/provider.dart";
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

  void signInUser() async {
    final navigator = Navigator.of(context);

    String result = await AuthMethods().signIn(
      emailOrUsername: _controllerEmailUsername.text,
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerEmailUsername.dispose();
    _controllerPassword.dispose();
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
        // appBar: AppBar(
        //   leading: svgIcon,
        //   title: Text(
        //     "Welcome back",
        //     style: Provider.of<ThemeProvider>(context)
        //         .getThemeData(context)
        //         .textTheme
        //         .displayLarge,
        //   ),
        // ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Padding(
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
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signInUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => ForgotPasswordScreen(),
                  //       ),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.grey.shade200,
                  //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     minimumSize: Size(double.infinity, 0),
                  //   ),
                  //   child: Text(
                  //     "Forgot your password?",
                  //     style: Provider.of<ThemeProvider>(context)
                  //         .getThemeData(context)
                  //         .textTheme
                  //         .bodyLarge!
                  //         .copyWith(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
