import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  //TODO:空の変数用意(メール、パスワード)
  String mail = '';
  String password = '';

//TODO:認証
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    final User mailPassUser = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    ))
        .user;

    final email = mailPassUser.email;
    FirebaseFirestore.instance
        .collection('users')
        .doc()
        .collection('user')
        .add({
      'mail_address': email,
      'created_at': Timestamp.now(),
    });
  }
}
