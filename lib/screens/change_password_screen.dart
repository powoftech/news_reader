import "package:flutter/material.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = "/change_password";
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRepeatPassword =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      appBar: AppBar(
        title: Text("Change Password",
            style: Provider.of<ThemeProvider>(context)
                .getThemeData(context)
                .textTheme
                .displayLarge,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  controller: _controllerEmail,
                  // validator: (value) => EmailValidator.validate(value!)
                  //     ? null
                  //     : "Please enter a valid email",
                  decoration: InputDecoration(
                    hintText: "Current password",
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
                  obscureText: _obscureText,),
              SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                decoration: InputDecoration(
                  hintText: "New password",
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
                obscureText: _obscureText,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _controllerRepeatPassword,
                decoration: InputDecoration(
                  hintText: "Repeat your new password",
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
                obscureText: _obscureText,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _obscureText ? "Show password" : "Hide password",
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reset Password",
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
            ],
          ),
        ),
      ),
    );
  }
}
