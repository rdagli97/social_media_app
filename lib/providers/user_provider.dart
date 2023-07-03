import 'package:event_app/models/user_model.dart';
import 'package:event_app/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    email: "",
    username: "",
    bio: "",
    photoUrl: "",
    uid: "",
    followers: [],
    following: [],
    myLikes: [],
  );

  UserModel get getUser => _user;

  final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUser() async {
    UserModel userModel = await _authMethods.getUserDetails();
    _user = userModel;
    notifyListeners();
  }

  void pushReplacementTo(BuildContext context, Widget widget) {
    pushReplacementTo(context, widget);
    notifyListeners();
  }
}
