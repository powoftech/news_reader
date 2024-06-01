import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/resources/auth_methods.dart";
import "package:news_reader/resources/firestore_methods.dart";
import "package:news_reader/screens/article_screen.dart";
import "package:news_reader/widgets/custom_tag.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";
import "package:timeago/timeago.dart" as timeago;

class NewsScreen extends StatefulWidget {
  static const routeName = "/";

  const NewsScreen({
    super.key,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with AutomaticKeepAliveClientMixin {
  final CollectionReference _articleCollection =
      FirebaseFirestore.instance.collection("article");

  final ScrollController _scrollController = ScrollController();
  int _limit = 10;
  bool _filledScreen = false;

  Future<void> _refreshArticles() async {
    await FirebaseFirestore.instance.clearPersistence();
    setState(() {});
  }

  Future<void> _fetchMoreArticles() async {
    setState(() {
      _limit += 10;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreArticles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const int newsOfTheDay = 1;

    super.build(context);

    final ThemeData themeData =
        Provider.of<ThemeProvider>(context).getThemeData(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeData.colorScheme.surface,
        extendBodyBehindAppBar: true,
        body: RefreshIndicator(
          color: isDarkMode ? Colors.white : Colors.black,
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          onRefresh: _refreshArticles,
          child: Padding(
            padding: EdgeInsets.zero,
            child: StreamBuilder<QuerySnapshot>(
              stream: _articleCollection
                  .orderBy("datePublished", descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                return Column(
                  children: [
                    if (!_filledScreen)
                      _NewsOfTheDay(
                        snap: snapshot.data!.docs[0],
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _filledScreen = !_filledScreen;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Breaking News",
                                    style: Provider.of<ThemeProvider>(context)
                                        .getThemeData(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  Icon(
                                    _filledScreen
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: ListView.separated(
                                controller: _scrollController,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 20),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                itemCount:
                                    snapshot.data!.docs.length - newsOfTheDay,
                                itemBuilder: (context, index) {
                                  QueryDocumentSnapshot snap =
                                      snapshot.data!.docs[index + newsOfTheDay];
                                  Map<String, dynamic> article =
                                      snap.data() as Map<String, dynamic>;

                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        viewArticle(context, snap);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ImageContainer(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                timeago.format(
                                                  (article["datePublished"]
                                                          as Timestamp)
                                                      .toDate(),
                                                ),
                                                style:
                                                    Provider.of<ThemeProvider>(
                                                  context,
                                                )
                                                        .getThemeData(context)
                                                        .textTheme
                                                        .bodyMedium,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  " by ${(article["author"] as List<dynamic>).map((item) => item.toString()).toList().join(", ")}",
                                                  style: Provider.of<
                                                          ThemeProvider>(
                                                    context,
                                                  )
                                                      .getThemeData(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    required this.snap,
  });

  final QueryDocumentSnapshot snap;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> article = snap.data() as Map<String, dynamic>;

    return InkWell(
      onTap: () {
        viewArticle(context, snap);
      },
      child: ImageContainer(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        imageUrl: article["image"],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              backgroundColor: Colors.grey.withAlpha(191),
              children: [
                Text(
                  "News of the Day",
                  style: Provider.of<ThemeProvider>(context)
                      .getThemeData(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              article["title"],
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(191, 0, 0, 0),
                    offset: Offset(1, 1),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> viewArticle(
  BuildContext context,
  DocumentSnapshot snap,
) async {
  FirestoreMethods().viewArticle(
    snap.id,
    AuthMethods().currentUser.uid,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ArticleScreen(
        snap: snap,
      ),
    ),
  );
}
