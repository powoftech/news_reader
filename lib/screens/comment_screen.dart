import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:news_reader/controllers/auth.dart";
import "package:news_reader/controllers/date_formatter.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

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

  bool _isKeyboardVisible = false;
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

  Widget _buildCommentInputField(
      Map<String, dynamic> commentData, Function updateUI) {
    final commentController = TextEditingController();
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
                if (commentData["comments"][0]["content"] == "") {
                  final commentRef = FirebaseFirestore.instance
                      .collection("comment")
                      .doc(commentData["article"].id);
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
                      .doc(commentData["article"].id);
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
              updateUI();
            },
          ),
        ],
      ),
    );
    // Your existing implementation of _buildCommentInputField using commentData
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
                } else if (!snapshot.hasData ||
                    !snapshot.data!.exists ||
                    snapshot.data!.get("comments")[0]["content"] == "") {
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
                        var commentRef = snapshot.data!;
                        return FutureBuilder(
                          future: getUsername(commentData["user"].id),
                          builder: (
                            context,
                            AsyncSnapshot<String> usernameSnapshot,
                          ) {
                            if (usernameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    MessageWidget(
                                      commentData: commentData,
                                      commentRef: commentRef,
                                      content: commentData["content"],
                                      sender:
                                          usernameSnapshot.data ?? "Unknown",
                                      timestamp:
                                          commentData["datePost"].toDate(),
                                    ),
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
            _buildCommentInputField(widget.comment, updateUI),
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
  var commentData;
  var commentRef;
  MessageWidget({
    Key? key,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.commentData,
    required this.commentRef,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool _isCurrentUser(String userId) {
    return Auth().currentUser?.uid == userId;
  }

  bool _isEditing = false;
  late TextEditingController _textEditingController; // Declare controller

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
        text: widget.content); // Initialize controller with content
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              "https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png?rev=2540745"),
          radius: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sender,
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
                child: _isEditing
                    ? _buildEditTextField()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.content,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormatter()
                                      .formattedDate(widget.timestamp),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                              if (_isCurrentUser(widget.commentData["user"].id))
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = true;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("comment")
                                            .doc(
                                              widget.commentRef
                                                  .get("article")
                                                  .id,
                                            )
                                            .update({
                                          "comments": FieldValue.arrayRemove(
                                            [widget.commentData],
                                          ),
                                        });
                                        // Implement delete functionality
                                      },
                                    ),
                                  ],
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

  Widget _buildEditTextField() {
    return TextField(
      controller: _textEditingController,
      autofocus: true, // Set autofocus to true to focus on the text field
      onSubmitted: (newValue) {
        setState(() {
          _isEditing = false;
          // Update the comment content in the database or wherever it's stored
        });
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose(); // Dispose the controller
    super.dispose();
  }
}
