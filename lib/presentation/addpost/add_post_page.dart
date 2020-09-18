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
      create: (_) => AddPostModel(user),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat投稿画面'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Consumer<AddPostModel>(builder: (context, model, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //TODO:投稿message入力画面

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '投稿メッセージ',
                      //TODO: 複数行のテキスト入力できる
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onChanged: (text) {
                      model.messageText = text;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text('投稿'),
                      onPressed: () async {
                        await model.addMessageToFirebase();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
