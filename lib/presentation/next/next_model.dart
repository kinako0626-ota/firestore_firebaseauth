import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NextModel extends ChangeNotifier {
  User userData;
  String name = '';
  String email;
  String photoURL;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  NextModel(User userData) {
    this.userData = userData;
    this.name = userData.displayName;
    this.email = userData.email;
    this.photoURL = userData.photoURL;
  }

  //TODO: Google SignOut
  Future googleWithSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    try {
      await googleSignIn.signOut();
    } catch (e) {
      return null;
    }
    //TODO: 前の画面に戻る
    Navigator.pop(context);
  }
}
