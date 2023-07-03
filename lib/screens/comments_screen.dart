import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/models/user_model.dart';
import 'package:event_app/providers/user_provider.dart';
import 'package:event_app/resources/firestore_methods.dart';
import 'package:event_app/screens/loading_screen.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final dynamic snap;
  const CommentsScreen({
    super.key,
    required this.snap,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pushReplacementTo(
              context,
              const LoadingScreen(),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              return Commentcard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kTextTabBarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                // pp
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    userModel.photoUrl,
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${userModel.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirestoreMethods().postComment(
                      postId: widget.snap['postId'],
                      text: _commentController.text,
                      uid: userModel.uid,
                      username: userModel.username,
                      profilePic: userModel.photoUrl,
                    );
                    _commentController.clear();
                  },
                  child: const Icon(
                    Icons.send_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
