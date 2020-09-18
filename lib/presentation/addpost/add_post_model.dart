import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPostModel extends ChangeNotifier {
  AddPostModel(this.user);
  final User user;
  String messageText = '';

  Future addMessageToFirebase() async {
    final date = DateTime.now().toLocal().toIso8601String();
    final email = user.email;
    final userName = user.displayName;

    if (messageText.isEmpty) {
      throw ('メッセージを入力してください');
    }
    await FirebaseFirestore.instance.collection('posts').doc().set({
      'text': messageText,
      'email': email,
      'date': date,
      'userName': userName,
    });
  }
}
