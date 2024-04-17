import 'package:flutter/material.dart';
import 'package:news_reader/models/article_model.dart';
import 'package:news_reader/screens/article_screen.dart';
import 'package:news_reader/widgets/image_container.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/discover';
  final List<Article> articles;
  const SearchScreen({super.key, required this.articles});
  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      'All',
      'World',
      'Politics',
      'Business',
      'Tech',
      'Science',
      'Sports',
      'Health',
    ];
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
          child: ListView(
            children: [
              const _DiscoverNews(),
              _CategoryNews(tabs: tabs, articles: articles)
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
    super.key,
    required this.tabs,
    required this.articles,
  });
  final List<String> tabs;
  final List<Article> articles;
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArticleScreen(article: articles[index]),
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
                                    Text(
                                      articles[index].title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
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
                                        Text(
                                            '${DateTime.now().difference(DateTime.parse(articles[index].publishedAt!)).inHours} hours ago',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        const Icon(
                                          Icons.visibility,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('1224 views',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
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
  const _DiscoverNews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Discover',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'News from all over the world',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search for news',
              fillColor: Colors.grey.shade200,
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
