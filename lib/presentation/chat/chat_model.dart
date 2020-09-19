import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/domain/chat.dart';
import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier {
  User user;

  ChatModel(this.user);
  String messageText = '';

  final textEditingController = TextEditingController();
  List<ChatEntry> chatEntries = [];

  Future fetchChatEntry() async {
    final docs = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date')
        .get();
    final chatEntries = docs.docs.map((doc) => ChatEntry(doc)).toList();
    this.chatEntries = chatEntries;
    notifyListeners();
  }

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
    notifyListeners();
  }

  Widget buildInputArea() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 16.0,
          height: 16.0,
        ),
        Expanded(
          child: TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: '投稿メッセージ'),
            onChanged: (text) {
              messageText = text;
            },
          ),
        ),
        IconButton(
            icon: Icon(Icons.send),
            color: Colors.lightBlue,
            onPressed: () async {
              if (messageText.isEmpty) {
                print('メッセージを入力してください');
                return null;
              } else {
                await addMessageToFirebase();
                textEditingController.clear();
              }
            })
      ],
    );
  }
}
