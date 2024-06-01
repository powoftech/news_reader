import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/screens/news_screen.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";
import "package:timeago/timeago.dart" as timeago;

class SearchArticleScreen extends StatelessWidget {
  const SearchArticleScreen({
    super.key,
    required this.keyword,
  });

  static const routeName = "/search-result";
  final String keyword;

  @override
  Widget build(BuildContext context) {
    final CollectionReference articleCollection =
        FirebaseFirestore.instance.collection("article");

    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Result for '$keyword'",
          style: Provider.of<ThemeProvider>(context)
              .getThemeData(context)
              .textTheme
              .displayLarge,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: articleCollection
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return const Center(child: Text("Something went wrong"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot snap = snapshot.data!.docs[index];
              Map<String, dynamic> article =
                  snap.data() as Map<String, dynamic>;

              if ((article["title"] as String)
                  .toLowerCase()
                  .contains(keyword.toLowerCase())) {
                return InkWell(
                  onTap: () {
                    viewArticle(context, snap);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                article["title"],
                                maxLines: 4,
                                overflow: TextOverflow.clip,
                                style: Provider.of<ThemeProvider>(context)
                                    .getThemeData(context)
                                    .textTheme
                                    .bodyLarge!,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      timeago.format(
                                        (article["datePublished"] as Timestamp)
                                            .toDate(),
                                      ),
                                      style: Provider.of<ThemeProvider>(
                                        context,
                                      )
                                          .getThemeData(context)
                                          .textTheme
                                          .bodyMedium,
                                      maxLines: 1, // Ensure single line
                                      overflow: TextOverflow
                                          .ellipsis, // Handle potential overflow
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.visibility,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${article["view"] as int} views",
                                    style: Provider.of<ThemeProvider>(context)
                                        .getThemeData(context)
                                        .textTheme
                                        .bodyMedium,
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ImageContainer(
                          width: 100,
                          height: 100,
                          borderRadius: 5,
                          imageUrl: article["image"],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: 0,
                );
              }
            },
          );
        },
      ),
    );
  }
}
