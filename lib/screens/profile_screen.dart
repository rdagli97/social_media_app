import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/resources/auth_methods.dart';
import 'package:event_app/resources/firestore_methods.dart';
import 'package:event_app/screens/chat_screen.dart';
import 'package:event_app/screens/login_screen.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/utils/show_snackbar.dart';
import 'package:event_app/widgets/container_tabbar.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:event_app/widgets/follow_button.dart';
import 'package:event_app/widgets/post_card.dart';
import 'package:event_app/widgets/send_message_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool showPosts = true;
  int myLikesLength = 0;
  List<dynamic> myLikesList = [];
  late String recieverUserUsername;

  @override
  void initState() {
    super.initState();
    getData();
    getMyLikesData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var myLikesSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      recieverUserUsername = userSnap.data()?['username'] ?? "";
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      userData = userSnap.data()!;
      myLikesLength = myLikesSnap.data()!['myLikes'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      //
      showSnackBar(
        context,
        e.toString(),
      );
    }
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
      myLikesLength = myLikes.length;
      myLikesList = myLikes;
      return myLikes;
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      return [];
    }
  }

  void toggleShowPosts() {
    setState(() {
      showPosts = !showPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(20),
                        // pp
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(
                            userData?['photoUrl'] ??
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/512px-Windows_10_Default_Profile_Picture.svg.png?20221210150350",
                          ),
                        ),
                        addVerticalSpace(10),
                        // username text
                        CustomText(
                          text: userData?['username'] ?? "",
                          fontWeight: FontWeight.w500,
                        ),
                        addVerticalSpace(20),
                        // bio text
                        CustomText(
                          text: userData?['bio'] ?? "",
                          fontStyle: FontStyle.italic,
                        ),
                        addVerticalSpace(20),
                        Row(
                          children: [
                            // number of following
                            CustomText(
                              text: '$following',
                              fontWeight: FontWeight.bold,
                            ),
                            addHorizontalSpace(5),
                            // following text
                            const CustomText(
                              text: 'Following',
                            ),
                            addHorizontalSpace(10),
                            // number of followers
                            CustomText(
                              text: '$followers',
                              fontWeight: FontWeight.bold,
                            ),
                            addHorizontalSpace(5),
                            // followers text
                            const CustomText(
                              text: 'Followers',
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                      ],
                    ),
                    Column(
                      children: [
                        // Follow / Logout  button
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? FollowButton(
                                onTap: () async {
                                  await AuthMethods().signOutUser();
                                  pushReplacementTo(
                                    context,
                                    const LoginScreen(),
                                  );
                                },
                                color: Colors.blue,
                                text: 'Signout',
                              )
                            : isFollowing
                                ? FollowButton(
                                    color: Colors.black,
                                    text: 'Unfollow -',
                                    onTap: () async {
                                      await FirestoreMethods().followUser(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        followId: userData!['uid'],
                                      );
                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    },
                                  )
                                : FollowButton(
                                    color: Colors.blue,
                                    text: 'Follow +',
                                    onTap: () async {
                                      await FirestoreMethods().followUser(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        followId: userData!['uid'],
                                      );
                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    },
                                  ),
                        // message button
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? const SizedBox()
                            : SendMessageButton(
                                onTap: () {
                                  pushTo(
                                    context,
                                    ChatScreen(
                                      recieverUserId: widget.uid,
                                      recieverUserUsername:
                                          recieverUserUsername,
                                    ),
                                  );
                                },
                                color: Colors.blue,
                                widget: const Icon(Icons.email),
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // tabbar view // or container
          Row(
            children: [
              ContainerTabbar(
                onTap: () => toggleShowPosts(),
                text: 'Posts',
                topLeftPadding: true,
                color: showPosts ? Colors.black : Colors.grey.withOpacity(0.2),
              ),
              ContainerTabbar(
                onTap: () => toggleShowPosts(),
                text: 'Likes',
                topLeftPadding: false,
                color: showPosts ? Colors.grey.withOpacity(0.2) : Colors.black,
              ),
            ],
          ),
          showPosts
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          return PostCard(
                            snap: snapshot.data!.docs[index].data(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: myLikesLength,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(myLikesList[index])
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return PostCard(
                              snap: snapshot.data!.data(),
                              isLikePage: true,
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error : ${snapshot.error}'),
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
