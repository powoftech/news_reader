import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/resources/auth_methods.dart";
import "package:news_reader/resources/firestore_methods.dart";
import "package:news_reader/screens/news_screen.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";
import "package:timeago/timeago.dart" as timeago;

class ReadLaterScreen extends StatefulWidget {
  const ReadLaterScreen({
    super.key,
  });
  static const routeName = "/readLater";

  @override
  State<ReadLaterScreen> createState() => _ReadLaterScreenState();
}

class _ReadLaterScreenState extends State<ReadLaterScreen>
    with AutomaticKeepAliveClientMixin {
  final uid = AuthMethods().currentUser.uid;
  final DocumentReference _readLaterDocument = FirebaseFirestore.instance
      .collection("readLater")
      .doc(AuthMethods().currentUser.uid);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getThemeData(context)
            .colorScheme
            .surface,
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 10),
                  Text(
                    "Read Later",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .headlineLarge,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _readLaterDocument.snapshots(),
                builder: (context, readLaterSnapshot) {
                  if (readLaterSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (readLaterSnapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }

                  List<dynamic> records =
                      readLaterSnapshot.data!["articles"] as List<dynamic>;

                  if (records.isEmpty) {
                    return Center(
                      child: Text("The list is empty."),
                    );
                  } else {
                    return ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> record = records[index];
                        DocumentReference articleDoc =
                            record["article"] as DocumentReference;

                        return FutureBuilder(
                          future: articleDoc.get(),
                          builder: (context, articleSnapshot) {
                            if (articleSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (articleSnapshot.hasError) {
                              return const Center(
                                child: Text("Something went wrong"),
                              );
                            }

                            Map<String, dynamic> article = articleSnapshot.data!
                                .data() as Map<String, dynamic>;

                            return Dismissible(
                              key: Key(articleSnapshot.data!.id),
                              onDismissed: (direction) async {
                                await FirestoreMethods()
                                    .readLaterArticle(
                                      articleSnapshot.data!.id,
                                      uid,
                                    )
                                    .then((value) => log(value));
                              },
                              background: Container(
                                color: Colors.red,
                                child: Center(
                                  child: Text("Remove"),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: InkWell(
                                    onTap: () {
                                      viewArticle(
                                          context, articleSnapshot.data!,);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ImageContainer(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          imageUrl: article["image"],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          article["title"],
                                          style: Provider.of<ThemeProvider>(
                                            context,
                                          )
                                              .getThemeData(context)
                                              .textTheme
                                              .bodyLarge!,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              timeago.format(
                                                (record["dateAdded"]
                                                        as Timestamp)
                                                    .toDate(),
                                              ),
                                              style: Provider.of<ThemeProvider>(
                                                context,
                                              )
                                                  .getThemeData(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
