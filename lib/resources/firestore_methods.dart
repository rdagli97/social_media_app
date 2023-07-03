import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/models/post_model.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost({
    required String postMessage,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occured";
    try {
      String postId = const Uuid().v1();
      Post post = Post(
        postMessage: postMessage,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // get post snapshots by time
  Stream<QuerySnapshot> getSortedPosts() {
    return _firestore
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots();
  }

  // like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // add liked post to myLikes list
  Future<void> addToMyLikes(String uid, String postId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List myLikes = (snap.data()! as dynamic)['myLikes'];
      if (myLikes.contains(postId)) {
        await _firestore.collection('users').doc(uid).update({
          "myLikes": FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          "myLikes": FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  // comment post
  Future<void> postComment({
    required String postId,
    required String text,
    required String uid,
    required String username,
    required String profilePic,
  }) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "postId": postId,
          "text": text,
          "uid": uid,
          "username": username,
          "profilePic": profilePic,
          "commentId": commentId,
          "datePublished": DateTime.now(),
          "commentLikes": [],
        });
      } else {
        debugPrint("something went wrong");
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  // like comments
  Future<void> likeComments({
    required String postId,
    required String commentId,
    required String uid,
    required List commentLikes,
  }) async {
    try {
      if (commentLikes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'commentLikes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'commentLikes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  // deleting post
  Future<void> deletePost(String postId, String uid) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List myLikesList = (snap.data()! as dynamic)['myLikes'];
      if (myLikesList.contains(postId)) {
        await _firestore.collection('users').doc(uid).update({
          "myLikes": FieldValue.arrayRemove([postId]),
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  // follow user
  Future<void> followUser({
    required String uid,
    required String followId,
  }) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        // if you already in followers list on it , then remove
        await _firestore.collection('users').doc(followId).update({
          "followers": FieldValue.arrayRemove([uid]),
        });
        // if it already in following list of you , then remove
        await _firestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayRemove([followId]),
        });
      } else {
        // if you not follow it , then add you to followers list of it
        await _firestore.collection('users').doc(followId).update({
          "followers": FieldValue.arrayUnion([uid]),
        });
        // if you not following it , then add it to your following list
        await _firestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }
}
