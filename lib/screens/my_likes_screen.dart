import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/widgets/post_card.dart';
import 'package:flutter/material.dart';

class MyLikesScreen extends StatefulWidget {
  final String uid;
  const MyLikesScreen({
    super.key,
    required this.uid,
  });

  @override
  State<MyLikesScreen> createState() => _MyLikesScreenState();
}

class _MyLikesScreenState extends State<MyLikesScreen> {
  int myLikesLength = 0;
  List<dynamic> myLikesList = [];

  @override
  void initState() {
    super.initState();
    getMyLikesData();
  }

  Future<List<dynamic>> getMyLikesData() async {
    try {
      DocumentSnapshot myLikesSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      Map<String, dynamic>? myLikesData =
          myLikesSnap.data() as Map<String, dynamic>?;
      List<dynamic> myLikes =
          myLikesData != null ? myLikesData['myLikes'] ?? [] : [];
      myLikesList = myLikes;
      myLikesLength = myLikes.length;
      setState(() {});
      return myLikes;
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myLikesList.length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(myLikesList[index])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return PostCard(
                        snap: snapshot.data!.data(),
                        isLikePage: true,
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error ${snapshot.error}'),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
