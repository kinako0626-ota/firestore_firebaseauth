import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/addpost/add_post_page.dart';
import 'package:firestore_firebaseauth/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
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
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text('ログイン情報：' + user.displayName),
            ),
            Consumer<ChatModel>(builder: (context, model, child) {
              return Expanded(
                // TODO:FutureBuilderを使い、非同期処理の結果を元にWidgetを作成
                child: FutureBuilder<QuerySnapshot>(
                  //TODO: 投稿メッセージ一覧を取得
                  //TODO: 投稿日時でソート
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('date')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> docs = snapshot.data.docs;
                      //TODO 取得した投稿メッセージ一覧を元にリスト表示
                      return ListView(
                        children: docs.map((doc) {
                          return Card(
                            child: ListTile(
                              title: Text(doc.data()['text']),
                              subtitle: Text(doc.data()['userName']),
                              onLongPress: () async {
                                //TODO: 自分の名前のところだけ削除可能
                                if (doc.data()['userName'] ==
                                    user.displayName) {
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(doc.id)
                                      .delete();
                                }
                              },
                            ),
                          );
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
          ],
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
