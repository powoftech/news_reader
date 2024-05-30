import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/auth.dart";
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

  Future<bool> createUserWithEmailAndPassword() async {
    try {
      final userCollectionRef = FirebaseFirestore.instance.collection("user");
      final querySnapshot = await userCollectionRef
          .where(
            "username",
            isEqualTo: _controllerUsername.text,
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception("The username is already in use by another account.");
      }

      String? uid = await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      final userDocumentRef = userCollectionRef.doc(uid);
      await userDocumentRef.set({
        "username": _controllerUsername.text,
        "status":
            FirebaseFirestore.instance.collection("userStatus").doc("active"),
        "type": FirebaseFirestore.instance.collection("userType").doc("reader"),
        "dateCreated": Timestamp.now(),
        "lastActive": Timestamp.now(),
        "email": _controllerEmail.text,
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          backgroundColor: Colors.red,
        ),
      );
    } on Exception catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().split(":")[1]),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      appBar: AppBar(
        title: Text(
          "Create new account",
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
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      return "The username must contain only\n\tletters,\n\tdigits,\n\tunderscores";
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
                    String error = "The password must contain at least";

                    if (!RegExp(r"[a-zA-z]").hasMatch(value!)) {
                      error += "\n\t1 letter,";
                    }
                    if (!RegExp(r"[0-9]").hasMatch(value)) {
                      error += "\n\t1 number,";
                    }
                    if (value.length < 10) {
                      error += "\n\t10 characters";
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
                      if (await createUserWithEmailAndPassword()) {
                        log("Successfully!");
                        Navigator.of(context).pop();
                      }
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
                    Navigator.of(context).pop();
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
