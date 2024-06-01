import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/screens/news_screen.dart";
import "package:news_reader/screens/search_result.dart";
import "package:news_reader/utils/utils.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";
import "package:timeago/timeago.dart" as timeago;

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final CollectionReference _articleCollection =
      FirebaseFirestore.instance.collection("article");

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<QuerySnapshot>(
      stream: _articleCollection
          .orderBy("datePublished", descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        final articles = snapshot.data!.docs
            .map((snap) => snap.data() as Map<String, dynamic>);
        final topics = articles.expand((article) {
          return (article["topic"] as List<dynamic>)
              .map((value) => value.toString().capitalize())
              .toSet();
        });

        return SafeArea(
          child: DefaultTabController(
            initialIndex: 0,
            length: topics.toSet().length,
            child: Scaffold(
              backgroundColor: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .colorScheme
                  .surface,
              extendBodyBehindAppBar: true,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      _DiscoverNews(),
                      Expanded(
                        child: _CategoryNews(
                          tabs: topics.toSet(),
                          snapshot: snapshot.data!.docs,
                          articles: articles.toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DiscoverNews extends StatefulWidget {
  const _DiscoverNews();

  @override
  State<_DiscoverNews> createState() => _DiscoverNewsState();
}

class _DiscoverNewsState extends State<_DiscoverNews>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.explore),
              SizedBox(width: 10),
              Text(
                "Discover",
                style: Provider.of<ThemeProvider>(context)
                    .getThemeData(context)
                    .textTheme
                    .headlineLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "News from all over the world",
            style: Provider.of<ThemeProvider>(context)
                .getThemeData(context)
                .textTheme
                .bodyMedium,
          ),
          const SizedBox(height: 20),
          Form(
            child: TextFormField(
              onFieldSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchArticleScreen(keyword: value),
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: "Search for news",
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: RotatedBox(
                  quarterTurns: 1,
                  child: const Icon(
                    Icons.tune,
                    color: Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryNews extends StatefulWidget {
  const _CategoryNews({
    required this.tabs,
    required this.snapshot,
    required this.articles,
  });

  final Set<dynamic> tabs;
  final List<QueryDocumentSnapshot> snapshot;
  final List<dynamic> articles;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: widget.tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            children: widget.tabs.map((tab) {
              final filteredArticles = widget.articles
                  .where(
                    (article) => (article["topic"] as List<dynamic>)
                        .contains(tab.toLowerCase()),
                  )
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return InkWell(
                    onTap: () {
                      viewArticle(context, widget.snapshot[index]);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ImageContainer(
                            width: 80,
                            height: 80,
                            borderRadius: 5,
                            imageUrl: article["image"],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                article["title"],
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: Provider.of<ThemeProvider>(context)
                                    .getThemeData(context)
                                    .textTheme
                                    .bodyLarge!,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.schedule, size: 18),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      timeago.format(
                                        (article["datePublished"] as Timestamp)
                                            .toDate(),
                                      ),
                                      style: Provider.of<ThemeProvider>(context)
                                          .getThemeData(context)
                                          .textTheme
                                          .bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.visibility, size: 18),
                                  const SizedBox(width: 5),
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
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
