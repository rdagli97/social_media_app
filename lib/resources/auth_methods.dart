import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/models/user_model.dart' as model;
import 'package:event_app/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get usermodel details

  Future<model.UserModel> getUserDetails() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    return model.UserModel.fromSnap(snap);
  }

  // signup user
  Future<String> sinUpUser({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // upload image to storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to our database
        model.UserModel user = model.UserModel(
          email: email,
          username: username,
          bio: bio,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          followers: [],
          following: [],
          myLikes: [],
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // log in user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "please fill the blanks";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // sign out user
  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
