import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String photoUrl;
  final String uid;
  final String bio;
  final List followers;
  final List following;
  final List myLikes;
  UserModel({
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.uid,
    required this.followers,
    required this.following,
    required this.myLikes,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "photoUrl": photoUrl,
        "uid": uid,
        "bio": bio,
        "followers": followers,
        "following": following,
        "myLikes": myLikes,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'] ?? "",
      username: snapshot['username'] ?? "",
      photoUrl: snapshot['photoUrl'] ?? "",
      uid: snapshot['uid'] ?? "",
      bio: snapshot['bio'] ?? "",
      followers: snapshot['followers'] ?? "",
      following: snapshot['following'] ?? "",
      myLikes: snapshot['myLikes'] ?? "",
    );
  }
}
