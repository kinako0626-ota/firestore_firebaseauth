import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/addpost/add_post_page.dart';
import 'package:firestore_firebaseauth/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ChatModel>(
      create: (_) => ChatModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat画面'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
        body: Center(
          child: Text(user.email),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPostPage(user),
              fullscreenDialog: true,
            ));
          },
        ),
      ),
    );
  }
}
