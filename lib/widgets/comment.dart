import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:news_reader/widgets/provider.dart";
import "package:provider/provider.dart";

class CommentWidget extends StatelessWidget {
  var comment;

  CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("user")
          .doc(comment["user"].id)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://louisville.edu/enrollmentmanagement/images/person-icon/image",
                ),
              ),
              SizedBox(width: 8.0), // Add some horizontal space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data?["username"] as String,
                      style: Provider.of<ThemeProvider>(context)
                          .getThemeData(context)
                          .textTheme
                          .titleLarge,
                    ),
                    Text(
                      comment["content"],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 8.0), // Add some vertical space
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Text('Error in fetching data');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
