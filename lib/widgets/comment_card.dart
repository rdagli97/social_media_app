import 'package:event_app/models/user_model.dart';
import 'package:event_app/providers/user_provider.dart';
import 'package:event_app/resources/firestore_methods.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Commentcard extends StatefulWidget {
  final dynamic snap;
  const Commentcard({
    super.key,
    required this.snap,
  });

  @override
  State<Commentcard> createState() => _CommentcardState();
}

class _CommentcardState extends State<Commentcard> {
  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Column(
            children: [
              // pp
              CircleAvatar(
                backgroundImage: NetworkImage(widget.snap['profilePic']),
              ),
              const Divider(),
            ],
          ),
          addHorizontalSpace(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // username
                  CustomText(
                    text: widget.snap['username'],
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                  addHorizontalSpace(150),
                  // published date
                  CustomText(
                    text: DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(10),
              // comment text
              CustomText(
                text: widget.snap['text'],
                fontWeight: FontWeight.w500,
              ),
              addVerticalSpace(10),
              Row(
                children: [
                  // comment like button
                  GestureDetector(
                    onTap: () async {
                      FirestoreMethods().likeComments(
                        postId: widget.snap['postId'],
                        commentId: widget.snap['commentId'],
                        uid: userModel.uid,
                        commentLikes: widget.snap['commentLikes'],
                      );
                    },
                    child: widget.snap['commentLikes'].contains(userModel.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                  addHorizontalSpace(5),
                  // comment like count
                  CustomText(
                    text: '${widget.snap['commentLikes'].length}',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
