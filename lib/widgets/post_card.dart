// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:event_app/models/user_model.dart';
import 'package:event_app/providers/user_provider.dart';
import 'package:event_app/resources/firestore_methods.dart';
import 'package:event_app/screens/comments_screen.dart';
import 'package:event_app/screens/profile_screen.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/utils/show_snackbar.dart';
import 'package:event_app/widgets/custom_text.dart';

// ignore: must_be_immutable
class PostCard extends StatefulWidget {
  final dynamic snap;
  bool isLikePage;
  PostCard({
    super.key,
    required this.snap,
    this.isLikePage = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLength = 0;

  @override
  void initState() {
    super.initState();
    getCommentLength();
  }

  void getCommentLength() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLength = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.65,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Column(
              children: [
                // pp
                GestureDetector(
                  onTap: () {
                    pushTo(context, ProfileScreen(uid: widget.snap['uid']));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'],
                    ),
                    radius: 24,
                  ),
                ),
                const Divider(),
              ],
            ),
            addHorizontalSpace(10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(10),
                      Row(
                        children: [
                          // username
                          CustomText(
                            text: widget.snap['username'],
                            fontWeight: FontWeight.bold,
                          ),
                          addHorizontalSpace(180),
                          // delete icon button
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shrinkWrap: true,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.snap['uid']
                                          ? 'Delete'
                                          : 'More info'
                                    ]
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              if (FirebaseAuth.instance
                                                      .currentUser!.uid ==
                                                  widget.snap['uid']) {
                                                FirestoreMethods().deletePost(
                                                  widget.snap['postId'],
                                                  widget.snap['uid'],
                                                );

                                                widget.isLikePage
                                                    ? pushReplacementTo(
                                                        context,
                                                        const LoadingScreen(),
                                                      )
                                                    : Navigator.of(context)
                                                        .pop();
                                                setState(() {});
                                              } else {
                                                // go to tweets owner profile
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      // posted message
                      CustomText(
                        text: widget.snap['postMessage'],
                        color: Colors.white,
                      ),
                      addVerticalSpace(20),
                      Row(
                        children: [
                          // like button
                          GestureDetector(
                            onTap: () async {
                              // like post
                              await FirestoreMethods().likePost(
                                widget.snap['postId'],
                                userModel.uid,
                                widget.snap['likes'],
                              );
                              await FirestoreMethods().addToMyLikes(
                                userModel.uid,
                                widget.snap['postId'],
                              );
                              setState(() {});
                            },
                            child: widget.snap['likes'].contains(userModel.uid)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                  ),
                          ),
                          addHorizontalSpace(2),
                          // like count
                          CustomText(
                            text: '${widget.snap['likes'].length}',
                          ),
                          addHorizontalSpace(10),
                          // comment button
                          GestureDetector(
                            onTap: () {
                              pushReplacementTo(
                                context,
                                CommentsScreen(
                                  snap: widget.snap,
                                ),
                              );
                            },
                            child: const Icon(Icons.mode_comment_outlined),
                          ),
                          addHorizontalSpace(2),
                          // comment count
                          CustomText(
                            text: '$commentLength',
                          ),
                          addHorizontalSpace(100),
                          // published date text
                          CustomText(
                            text: DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            fontStyle: FontStyle.italic,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
