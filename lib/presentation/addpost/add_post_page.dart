import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/addpost/add_post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<AddPostModel>(
      create: (_) => AddPostModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat投稿画面'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('戻る'),
            onPressed: () {
              // 1つ前の画面に戻る
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
