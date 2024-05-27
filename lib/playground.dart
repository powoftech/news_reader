// final uid = Auth().currentUser?.uid;

//           final historyRef = FirebaseFirestore.instance.collection("history");
//           final history = historyRef.doc(uid);
//           final historyData = await history.get();

//           // final articleRef = historyData.data()?["articles"][0]["article"];

//           // if (articleRef != null) {
//           //   final articleData = await articleRef.get();
//           //   print("Article data: ${articleData.data()}");
//           // }

//           // final userRef = FirebaseFirestore.instance.collection("user");
//           // final user = userRef.doc(uid);

//           final articleRef = FirebaseFirestore.instance.collection("article");
//           final article =
//               articleRef.doc("01349d4d9fabef61a40b7aa053a9741febcbbed6c39d261829014ba865786a90");

//           history.update({
//             "articles": FieldValue.arrayUnion([
//               {
//                 "article": article,
//                 "dateRead": Timestamp.now(),
//               }
//             ])
//           });
//           // final historyRef = FirebaseFirestore.instance.collection("history").doc(uid);
//           // await historyRef.set({
//           //   "user": user,
//           //   "articles": {
//           //     {
//           //       "article": article,
//           //       "dateRead": Timestamp.now(),
//           //     },
//           //   },
//           // });