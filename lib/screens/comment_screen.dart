import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/controllers/date_formatter.dart";

class CommentsScreen extends StatefulWidget {
  final Map<String, dynamic> comment;

  const CommentsScreen({Key? key, required this.comment}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  void updateUI() {
    setState(() {});
  }

  var _commentsStream;
  @override
  void initState() {
    super.initState();
    _commentsStream = FirebaseFirestore.instance
        .collection("comment")
        .doc(widget.comment["article"].id)
        .snapshots();
  }

  Future<String> getUsername(String userId) async {
    try {
      var docSnapshot =
          await FirebaseFirestore.instance.collection("user").doc(userId).get();

      if (docSnapshot.exists) {
        var userData = docSnapshot.data();
        var username = userData!["username"];
        return username.toString();
      } else {
        return "User not found";
      }
    } catch (error) {
      print("Error fetching user data: $error");
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _commentsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Column(
                    children: [
                      Text("No comments yet"),
                      SizedBox(height: 16),
                    ],
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.get("comments").length,
                      itemBuilder: (context, index) {
                        var commentData = snapshot.data!.get("comments")[index];
                        return FutureBuilder(
                          future: getUsername(commentData["user"].id),
                          builder: (context,
                              AsyncSnapshot<String> usernameSnapshot) {
                            if (usernameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    MessageWidget(
                                      content: commentData["content"],
                                      sender:
                                          usernameSnapshot.data ?? "Unknown",
                                      timestamp:
                                          commentData["datePost"].toDate(),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
            _buildCommentInputField(
              comment: widget.comment,
              updateUI: updateUI,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final String content;
  final String sender;
  final DateTime timestamp;

  MessageWidget({
    Key? key,
    required this.content,
    required this.sender,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.sender,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          widget.content,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          DateFormatter().formattedDate(
              widget.timestamp), // Format the timestamp as needed
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Divider(thickness: 1.0),
      ],
    );
  }
}

class _buildCommentInputField extends StatefulWidget {
  _buildCommentInputField({
    super.key,
    required this.comment,
    required this.updateUI,
  });
  var comment;
  final VoidCallback updateUI;
  @override
  State<_buildCommentInputField> createState() =>
      _buildCommentInputFieldState();
}

class _buildCommentInputFieldState extends State<_buildCommentInputField> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  commentController, // Assign the controller to the TextField
              decoration: InputDecoration(
                hintText: "Write a comment...",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              final String commentText = commentController.text;
              if (commentText.isNotEmpty) {
                if (widget.comment["comments"][0]["content"] == "") {
                  final commentRef = FirebaseFirestore.instance
                      .collection("comment")
                      .doc(widget.comment["article"].id);
                  await commentRef.update({
                    "comments": ([
                      {
                        "content": commentText,
                        "datePost": Timestamp.now(),
                        "user": FirebaseFirestore.instance
                            .collection("user")
                            .doc(Auth().currentUser?.uid),
                      }
                    ]),
                  });
                } else {
                  final commentRef = FirebaseFirestore.instance
                      .collection("comment")
                      .doc(widget.comment["article"].id);
                  await commentRef.update({
                    "comments": FieldValue.arrayUnion([
                      {
                        "content": commentText,
                        "datePost": Timestamp.now(),
                        "user": FirebaseFirestore.instance
                            .collection("user")
                            .doc(Auth().currentUser?.uid),
                      }
                    ]),
                  });
                }
              }
              commentController.clear();
              widget.updateUI();
            },
          ),
        ],
      ),
    );
  }
}
