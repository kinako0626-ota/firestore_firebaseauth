import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firestore_firebaseauth/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage(this.user);
  final User user;

  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ChatModel>(
      create: (_) => ChatModel(user)..fetchChatEntry(),
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
        body: Column(
          children: [
            Bubble(
              alignment: Alignment.center,
              color: Color.fromRGBO(212, 234, 244, 1.0),
              child: Text('TODAY',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0)),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
            ),
            Consumer<ChatModel>(builder: (context, model, child) {
              return Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  //TODO: 投稿メッセージ一覧を取得
                  //TODO: 投稿日時でソート
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> docs = snapshot.data.docs;
                      //TODO 取得した投稿メッセージ一覧を元にリスト表示
                      return ListView(
                        children: docs.map((doc) {
                          return Bubble(
                            child: Text(doc.data()['text']),
                            color: Color.fromRGBO(212, 234, 244, 1.0),
                            alignment: Alignment.center,
                          );
                          // return Card(
                          //   child: ListTile(
                          //     title: Text(doc.data()['text']),
                          //     subtitle: Text(doc.data()['userName']),
                          //     onLongPress: () async {
                          //       //TODO: 自分の名前のところだけ削除可能
                          //       if (doc.data()['userName'] ==
                          //           user.displayName) {
                          //         await FirebaseFirestore.instance
                          //             .collection('posts')
                          //             .doc(doc.id)
                          //             .delete();
                          //       }
                          //     },
                          //   ),
                          // );
                        }).toList(),
                      );
                    }
                    return Center(
                      child: Loading(
                        indicator: BallBeatIndicator(),
                        size: 100.0,
                        color: Colors.black26,
                      ),
                    );
                  },
                ),
              );
            }),
            Consumer<ChatModel>(builder: (context, model, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: model.buildInputArea(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
