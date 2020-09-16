import 'package:firestore_firebaseauth/presentation/addpost/add_post_page.dart';
import 'package:firestore_firebaseauth/presentation/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

class ChatPage extends StatelessWidget {
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
              icon: Icon(Icons.close),
              onPressed: () async {
                await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPostPage(),
              fullscreenDialog: true,
            ));
          },
        ),
      ),
    );
  }
}
