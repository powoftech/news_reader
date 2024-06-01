import "dart:async";
import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/resources/auth_methods.dart";
import "package:news_reader/resources/firestore_methods.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";
import "package:text_scroll/text_scroll.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:timeago/timeago.dart" as timeago;

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key, required this.snap});
  final DocumentSnapshot snap;

  static const routeName = "/article";

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final ValueNotifier<bool> isInReadLater;
  late final DocumentReference _commentCollection;
  bool isComment = false;

  @override
  void initState() {
    isInReadLater = ValueNotifier<bool>(false);

    FirestoreMethods()
        .isArticleInReadLater(widget.snap.id, AuthMethods().currentUser.uid)
        .then((value) {
      setState(() {
        isInReadLater.value = value;
      });
    });

    _commentCollection =
        FirebaseFirestore.instance.collection("comment").doc(widget.snap.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> controller =
        Completer<WebViewController>();

    final Map<String, dynamic> article =
        (widget.snap.data() as Map<String, dynamic>);

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: TextScroll(
                  "${article["title"]}",
                  pauseBetween: Duration(seconds: 1),
                ),
                actions: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isInReadLater,
                    builder: (context, value, child) {
                      return IconButton(
                        icon: Icon(
                          value ? Icons.bookmark : Icons.bookmark_outline,
                        ),
                        onPressed: () async {
                          String result =
                              await FirestoreMethods().readLaterArticle(
                            widget.snap.id,
                            AuthMethods().currentUser.uid,
                          );

                          if (result == "Success") {
                            setState(() {
                              isInReadLater.value = !value;
                            });
                          }
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.comment_outlined),
                    onPressed: () {
                      setState(() {
                        isComment = true;
                      });
                    },
                  ),
                ],
              ),
              body: WebView(
                initialUrl: article["url"],
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (
                  WebViewController webViewController,
                ) {
                  controller.complete(webViewController);
                },
              ),
            ),
          ),
          if (isComment)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  log("Clicked");
                  setState(() {
                    isComment = !isComment;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ),
          if (isComment)
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Comments"),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            isComment = !isComment;
                          });
                        },
                      ),
                    ],
                  ),
                  body: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: _commentCollection.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text("Something went wrong"),
                              );
                            }

                            if (!snapshot.data!.exists) {
                              return Center(
                                child: Text(
                                    "No comments yet\nSay something to start the conversation",),
                              );
                            }

                            List<dynamic> records =
                                snapshot.data!["comments"] as List<dynamic>;

                            if (records.isEmpty) {
                              return Center(
                                child: Text(
                                    "No comments yet\nSay something to start the conversation",),
                              );
                            } else {
                              return Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: records.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> record =
                                        records[index];
                                    DocumentReference userDoc =
                                        record["user"] as DocumentReference;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("user")
                                            .doc(userDoc.id)
                                            .get(),
                                        builder: (
                                          context,
                                          userSnapshot,
                                        ) {
                                          if (userSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (userSnapshot.hasError) {
                                            return const Center(
                                              child:
                                                  Text("Something went wrong"),
                                            );
                                          }

                                          Map<String, dynamic> user =
                                              userSnapshot.data!.data()
                                                  as Map<String, dynamic>;

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                Message(
                                                  record: record,
                                                  user: user,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        CommentInput(
                          articleId: widget.snap.id,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final Map<String, dynamic> record;
  final Map<String, dynamic> user;

  const Message({
    super.key,
    required this.record,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            "https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png?rev=2540745",
          ),
          radius: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user["username"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context)
                              .getThemeData(context)
                              .colorScheme
                              .brightness ==
                          Brightness.light
                      ? Colors.grey[300]
                      : Colors.black38,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record["content"],
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            timeago.format(
                              (record["datePost"] as Timestamp).toDate(),
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommentInput extends StatelessWidget {
  const CommentInput({super.key, required this.articleId});
  final String articleId;

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "Write a comment...",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              String content = commentController.text;

              if (content.isNotEmpty) {
                await FirestoreMethods().postComment(
                  articleId,
                  AuthMethods().currentUser.uid,
                  content,
                );
              }
              commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}
