import "package:flutter/material.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/models/favorite_model.dart";
import "package:news_reader/models/history_model.dart";
import "package:news_reader/screens/article_screen.dart";
import "package:news_reader/widgets/firebase_alteration.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/theme_provider.dart";
import "package:provider/provider.dart";

class SearchScreen extends StatelessWidget {
  static const routeName = "/discover";
  final List<Article> articles;
  final HistoryModel history;
  final Favorite favorite;
  const SearchScreen(
      {super.key,
      required this.articles,
      required this.history,
      required this.favorite});
  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "All",
      "World",
      "Politics",
      "Business",
      "Tech",
      "Science",
      "Sports",
      "Health",
    ];
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getThemeData(context)
            .colorScheme
            .surface,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
          child: ListView(
            children: [
              const _DiscoverNews(),
              _CategoryNews(
                  tabs: tabs,
                  articles: articles,
                  favorite: favorite,
                  history: history),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<Widget> tabs;

  CustomTabBar({required this.tabs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: tab,
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({
    required this.tabs,
    required this.articles,
    required this.favorite,
    required this.history,
  });
  final List<String> tabs;
  final List<Article> articles;
  final Favorite favorite;
  final HistoryModel history;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: tabs
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
                .toList()),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: TabBarView(
            children: tabs
                .map((tab) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: 9,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () async {
                            articles[index + 1].view =
                                (int.parse(articles[index + 1].view!) + 1)
                                    .toString();
                            await updateFieldInFirebase(
                                "article",
                                articles[index + 1].id!,
                                "view",
                                int.parse(articles[index + 1].view!));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleScreen(
                                  article: articles[index],
                                  favorite: favorite,
                                  history: history,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ImageContainer(
                                  width: 80,
                                  height: 80,
                                  borderRadius: 5,
                                  imageUrl: articles[index].urlToImage!,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(articles[index].title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                        style:
                                            Provider.of<ThemeProvider>(context)
                                                .getThemeData(context)
                                                .textTheme
                                                .bodyLarge!),
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
                                            "${articles[index].publishedAt}",
                                            style: Provider.of<ThemeProvider>(
                                                    context)
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
                                          "${articles[index].view} views",
                                          style: Provider.of<ThemeProvider>(
                                                  context)
                                              .getThemeData(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Discover",
              style: Provider.of<ThemeProvider>(context)
                  .getThemeData(context)
                  .textTheme
                  .headlineLarge),
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
          TextFormField(
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
        ],
      ),
    );
  }
}
