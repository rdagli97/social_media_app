import 'package:event_app/models/user_model.dart';
import 'package:event_app/providers/user_provider.dart';
import 'package:event_app/resources/firestore_methods.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/utils/show_snackbar.dart';
import 'package:event_app/widgets/bottom_nav_bar.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:event_app/widgets/send_post_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendPostScreen extends StatefulWidget {
  const SendPostScreen({super.key});

  @override
  State<SendPostScreen> createState() => _SendPostScreenState();
}

class _SendPostScreenState extends State<SendPostScreen> {
  final TextEditingController _postController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  void postSend({
    required String uid,
    required String username,
    required String profImage,
  }) async {
    try {
      if (_postController.text.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        String res = await FirestoreMethods().uploadPost(
          postMessage: _postController.text,
          uid: uid,
          username: username,
          profImage: profImage,
        );
        if (res == "success") {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(context, 'Successfully posted');
          _postController.clear();
          pushReplacementTo(
            context,
            const BottomNavBar(),
          );
        } else {
          showSnackBar(context, res);
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        showSnackBar(context, 'There is nothing to post');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 13),
          child: Column(
            children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              addVerticalSpace(100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      addVerticalSpace(20),
                      // pp
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          user.photoUrl,
                        ),
                      ),
                    ],
                  ),
                  // post textfield
                  SendPostTextfield(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.2,
                    controller: _postController,
                    hintText: 'Send post',
                  ),
                  Column(
                    children: [
                      addVerticalSpace(10),
                      // send button
                      IconButton(
                        onPressed: () => postSend(
                          profImage: user.photoUrl,
                          uid: user.uid,
                          username: user.username,
                        ),
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey.shade100,
                        ),
                      ),
                      addVerticalSpace(20),
                      // cancel button
                      GestureDetector(
                        onTap: () {
                          _postController.clear();
                          pop(context);
                        },
                        child: const CustomText(
                          text: 'Cancel',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
