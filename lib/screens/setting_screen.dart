import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:news_reader/resources/auth_methods.dart";
import "package:news_reader/utils/utils.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static const routeName = "/setting";

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  final uid = AuthMethods().currentUser.uid;

  @override
  bool get wantKeepAlive => true;

  Future<void> signOut() async {
    await AuthMethods().signOut();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget svgIcon = SvgPicture.asset(
      "assets/icon/play_store_512.svg",
      colorFilter: ColorFilter.mode(
        context.isDarkMode ? Colors.white : Colors.black,
        BlendMode.srcIn,
      ),
      height: 96,
      semanticsLabel: "",
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getThemeData(context)
            .colorScheme
            .surface,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: AuthMethods().getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    svgIcon,
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data!.username,
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .displayMedium,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      snapshot.data!.email,
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleLarge,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    // InkWell(
                    //   onTap: () {
                    //     showDialog<void>(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         final formKey = GlobalKey<FormState>();
                    //         final TextEditingController currentController =
                    //             TextEditingController();
                    //         final TextEditingController newController =
                    //             TextEditingController();
                    //         final TextEditingController confirmController =
                    //             TextEditingController();
                    //         bool obscureText = true;

                    //         return AlertDialog(
                    //           title: const Text("Change password"),
                    //           content: Container(
                    //             height: 200,
                    //             width: 400,
                    //             child: Form(
                    //               key: formKey,
                    //               autovalidateMode:
                    //                   AutovalidateMode.onUserInteraction,
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.center,
                    //                 children: [
                    //                   TextFormField(
                    //                     controller: currentController,
                    //                     validator: (value) {
                    //                       if (value!.isEmpty) {
                    //                         return "The current password can't be empty";
                    //                       } else {
                    //                         return null;
                    //                       }
                    //                     },
                    //                     obscureText: true,
                    //                     decoration: InputDecoration(
                    //                       hintText: "Current password",
                    //                     ),
                    //                   ),
                    //                   TextFormField(
                    //                     controller: newController,
                    //                     validator: (value) {
                    //                       if (value!.length < 10) {
                    //                         return "The password must contain at least 10 characters";
                    //                       } else {
                    //                         return null;
                    //                       }
                    //                     },
                    //                     obscureText: true,
                    //                     decoration: InputDecoration(
                    //                       hintText: "New password",
                    //                     ),
                    //                   ),
                    //                   TextFormField(
                    //                     controller: confirmController,
                    //                     validator: (value) {
                    //                       if (value! == newController.text) {
                    //                         return null;
                    //                       } else {
                    //                         return "Those passwords didn't match. Try again";
                    //                       }
                    //                     },
                    //                     obscureText: true,
                    //                     decoration: InputDecoration(
                    //                       hintText: "Confirm password",
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //           actions: <Widget>[
                    //             TextButton(
                    //               style: TextButton.styleFrom(
                    //                 textStyle:
                    //                     Theme.of(context).textTheme.labelLarge,
                    //               ),
                    //               child: const Text("Cancel"),
                    //               onPressed: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //             ),
                    //             TextButton(
                    //               style: TextButton.styleFrom(
                    //                 textStyle:
                    //                     Theme.of(context).textTheme.labelLarge,
                    //               ),
                    //               child: const Text("Change"),
                    //               onPressed: () {
                    //                 if (formKey.currentState!.validate()) {}
                    //               },
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.key),
                    //       SizedBox(width: 5),
                    //       Text(
                    //         "Change password",
                    //         style: Provider.of<ThemeProvider>(context)
                    //             .getThemeData(context)
                    //             .textTheme
                    //             .titleLarge,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    SizedBox(
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
                            SizedBox(
                              width: 10,
                            ), // Add some spacing between icon and text
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
                    ),
                    SizedBox(height: 20),
                    Text(
                      "App version: 1.0.0",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
