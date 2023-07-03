import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postMessage;
  final String uid;
  final String username;
  final String postId;
  final dynamic datePublished;
  final String profImage;
  final dynamic likes;

  Post({
    required this.postMessage,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "postMessage": postMessage,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      postMessage: snapshot["postMessage"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      profImage: snapshot["profImage"],
      likes: snapshot["likes"],
    );
  }
}
