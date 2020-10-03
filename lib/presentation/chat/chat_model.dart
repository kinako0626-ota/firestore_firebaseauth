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

//TODO: message入力部分
  Widget buildInputArea() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 16.0,
          height: 16.0,
        ),
        Expanded(
          child: TextFormField(
            autofocus: true,
            controller: textEditingController,
            decoration: InputDecoration(labelText: '投稿メッセージ'),
            onChanged: (text) {
              messageText = text;
              notifyListeners();
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

//TODO: 9・26追加分
  Widget buildChatArea(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int index) {
              return buildRow(index);
            },
            itemCount: chatEntries.length,
          ),
        ),
        Divider(
          height: 4.0,
        ),
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: buildInputArea())
      ],
    );
  }

  buildRow(int index) {
    ChatEntry entry = chatEntries[index];
    return Container(
        margin: EdgeInsets.only(top: 8.0),
        child: user.email == entry.userEmail
            ? currentUserCommentRow(entry)
            : otherUserCommentRow(entry));
  }

  currentUserCommentRow(ChatEntry entry) {
    return Row(children: <Widget>[
      Container(child: avatarLayout(entry)),
      SizedBox(
        width: 16.0,
      ),
      Expanded(child: messageLayout(entry, CrossAxisAlignment.start)),
    ]);
  }

  otherUserCommentRow(ChatEntry entry) {
    return Row(children: <Widget>[
      Expanded(child: messageLayout(entry, CrossAxisAlignment.end)),
      SizedBox(
        width: 16.0,
      ),
      Container(child: avatarLayout(entry)),
    ]);
  }

  Widget messageLayout(ChatEntry entry, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text(entry.userName,
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        Text(entry.text)
      ],
    );
  }

  Widget avatarLayout(ChatEntry entry) {
    return CircleAvatar(
      backgroundImage: NetworkImage(entry.userPhotoURL),
    );
  }
}
