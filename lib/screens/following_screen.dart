import "dart:ffi";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/controllers/date_formatter.dart";
import "package:news_reader/controllers/firebase_alteration.dart";
import "package:news_reader/models/article_model.dart";
import "package:news_reader/screens/article_screen.dart";
import "package:news_reader/widgets/image_container.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

// ignore: must_be_immutable
class FollowingScreen extends StatefulWidget {
  FollowingScreen({
    super.key,
    required this.favorite,
    required this.history,
    required this.articles,
  });
  DocumentReference<Map<String, dynamic>> favorite;
  DocumentReference<Map<String, dynamic>> history;
  Query<Map<String, dynamic>> articles;
  static const routeName = "/following";

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        widget.favorite.get(),
        widget.history.get(),
        widget.articles.get(),
      ]),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Object?>>
            snapshot, // Update the type of the snapshot parameter
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
          ); // Show error if there is any
        } else {
          dynamic favoriteData = (snapshot.data![0] as DocumentSnapshot).data();
          dynamic historyData = (snapshot.data![1] as DocumentSnapshot).data();
          dynamic articles = (snapshot.data![2] as QuerySnapshot).docs;
          final articlesFavorite = favoriteData["articles"];
          final articlesHistory = historyData["articles"];
          return _NotEmptyHistoryAndFavorite(
            favoriteArticle: articlesFavorite,
            historyArticle: articlesHistory,
            favoriteRef: widget.favorite,
            historyRef: widget.history,
            articles: articles,
            updateUI: updateUI,
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class _NotEmptyHistoryAndFavorite extends StatefulWidget {
  _NotEmptyHistoryAndFavorite({
    required this.articles,
    required this.favoriteArticle,
    required this.historyArticle,
    required this.updateUI,
    required this.favoriteRef,
    required this.historyRef,
  });
  var articles;
  var favoriteArticle;
  var historyArticle;
  var favoriteRef;
  var historyRef;
  final VoidCallback updateUI;

  @override
  State<_NotEmptyHistoryAndFavorite> createState() =>
      _NotEmptyHistoryAndFavoriteState();
}

class _NotEmptyHistoryAndFavoriteState
    extends State<_NotEmptyHistoryAndFavorite> {
  final List<int> selectedFavoriteArticles = [];
  final List<int> selectedHistoryArticles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context)
          .getThemeData(context)
          .colorScheme
          .surface,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            if (Provider.of<DeleteModeProvider>(context)
                .isDeleteModeActive) // Show delete icon based on global state
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 60, bottom: 10),
                    child: InkWell(
                      onTap: () async {
                        for (var index in selectedFavoriteArticles) {
                          handleDeleteArticle(
                            context,
                            "favorite",
                            widget.historyArticle,
                            widget.favoriteArticle,
                            index,
                          );
                        }
                        for (var index in selectedHistoryArticles) {
                          handleDeleteArticle(
                            context,
                            "history",
                            widget.historyArticle,
                            widget.favoriteArticle,
                            index,
                          );
                        }
                        Provider.of<DeleteModeProvider>(
                          context,
                          listen: false,
                        ).deactivateDeleteMode();
                        selectedFavoriteArticles.clear();
                        selectedHistoryArticles.clear();
                        widget.updateUI();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              "Delete (${selectedFavoriteArticles.length + selectedHistoryArticles.length})",
                              style: Provider.of<ThemeProvider>(context)
                                  .getThemeData(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.red,
                                  )),
                          Icon(Icons.delete, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    margin: EdgeInsets.only(top: 60, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Provider.of<DeleteModeProvider>(
                          context,
                          listen: false,
                        ).deactivateDeleteMode();
                        selectedFavoriteArticles.clear();
                        selectedHistoryArticles.clear();
                        widget.updateUI();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Cancel",
                            style: Provider.of<ThemeProvider>(context)
                                .getThemeData(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Colors.blue,
                                ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.cancel, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (!Provider.of<DeleteModeProvider>(context).isDeleteModeActive)
              SizedBox(height: 90),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 10),
                  Text(
                    "Later Readings",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .displayLarge,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.favoriteArticle.length,
                separatorBuilder: (context, index) => SizedBox(height: 30),
                itemBuilder: (context, index) {
                  if (widget.favoriteArticle[index]["article"] == "") {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Empty",
                          style: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .textTheme
                              .headlineSmall!,
                        ),
                      ),
                    );
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: GestureDetector(
                      onLongPressStart: (_) => Provider.of<DeleteModeProvider>(
                        context,
                        listen: false,
                      ).activateDeleteMode(), // Activate global delete mode

                      // Handle individual article deletion
                      onTap: () async {
                        await updateFieldInFirebase(
                          "article",
                          widget.favoriteArticle[index]["article"].id,
                          "view",
                          getArticleById(
                                widget.articles,
                                widget.favoriteArticle[index]["article"].id,
                              )["view"] +
                              1,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleScreen(
                              article: getArticleById(
                                widget.articles,
                                widget.favoriteArticle[index]["article"].id,
                              ),
                              history: widget.historyRef,
                              favorite: widget.favoriteRef,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Provider.of<DeleteModeProvider>(context)
                              .isDeleteModeActive)
                            // Show checkbox only in delete mode
                            Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.only(right: 10),
                              child: Checkbox(
                                value: selectedFavoriteArticles.contains(
                                  index,
                                ),
                                onChanged: (value) => setState(() {
                                  if (value!) {
                                    selectedFavoriteArticles.add(index);
                                  } else {
                                    selectedFavoriteArticles.remove(index);
                                  }
                                }),
                              ),
                            ),
                          ImageContainer(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: getArticleById(
                              widget.articles,
                              widget.favoriteArticle[index]["article"].id,
                            )["image"],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            getArticleById(
                              widget.articles,
                              widget.favoriteArticle[index]["article"].id,
                            )["title"],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormatter().formattedDate(
                                  getArticleById(
                                    widget.articles,
                                    widget.historyArticle[index]["article"].id,
                                  )["datePublished"]
                                      .toDate(),
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Flexible(
                                child: Text(
                                  " by ${List<String>.from(getArticleById(
                                    widget.articles,
                                    widget.favoriteArticle[index]["article"].id,
                                  )["author"]).map((e) => e.toString()).toList().join(", ")}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
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
            Padding(
              padding: EdgeInsets.only(left: 20, top: 40),
              child: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 10),
                  Text(
                    "History",
                    style: Provider.of<ThemeProvider>(context)
                        .getThemeData(context)
                        .textTheme
                        .displayLarge,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.historyArticle.length,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  if (widget.historyArticle[index]["article"] == "") {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Empty",
                          style: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .textTheme
                              .headlineSmall!,
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(right: 10, left: 20),
                      child: GestureDetector(
                        onLongPressStart: (_) =>
                            Provider.of<DeleteModeProvider>(
                          context,
                          listen: false,
                        ).activateDeleteMode(), // Activate global delete mode

                        onTap: () async {
                          await updateFieldInFirebase(
                            "article",
                            getArticleById(widget.articles,
                                    widget.historyArticle[index]["article"].id)
                                .id!,
                            "view",
                            getArticleById(
                                  widget.articles,
                                  widget.historyArticle[index]["article"].id,
                                )["view"] +
                                1,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleScreen(
                                article: getArticleById(
                                  widget.articles,
                                  widget.historyArticle[index]["article"].id,
                                ),
                                history: widget.historyRef,
                                favorite: widget.favoriteRef,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (Provider.of<DeleteModeProvider>(context)
                                .isDeleteModeActive)
                              // Show checkbox only in delete mode
                              Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.only(right: 10),
                                child: Checkbox(
                                  value:
                                      selectedHistoryArticles.contains(index),
                                  onChanged: (value) => setState(() {
                                    if (value!) {
                                      selectedHistoryArticles.add(
                                        index,
                                      );
                                    } else {
                                      selectedHistoryArticles.remove(
                                        index,
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ImageContainer(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              imageUrl: getArticleById(
                                widget.articles,
                                widget.historyArticle[index]["article"].id,
                              )["image"],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              getArticleById(
                                  widget.articles,
                                  widget.historyArticle[index]["article"]
                                      .id)["title"],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormatter().formattedDate(
                                    getArticleById(
                                      widget.articles,
                                      widget
                                          .historyArticle[index]["article"].id,
                                    )["datePublished"]
                                        .toDate(),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Flexible(
                                  child: Text(
                                    " by ${List<String>.from(getArticleById(
                                      widget.articles,
                                      widget
                                          .historyArticle[index]["article"].id,
                                    )["author"]).map((e) => e.toString()).toList().join(", ")}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
