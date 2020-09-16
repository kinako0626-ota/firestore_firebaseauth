import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/next/next_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextPage extends StatelessWidget {
  //TODO:イニシャライザ。。初期化したときに値を定義できるのでNextPageのuserを初期化時にセット
  NextPage(this.user);
  //TODO:遷移先のこのクラスでuserを受け取ったのでこれでuserを使える様になった
  final User user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NextModel>(
      create: (_) => NextModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('遷移先'),
        ),
        body: Consumer<NextModel>(
          builder: (context, model, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL),
                  ),
                  Text(
                    '${user.displayName}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${user.email}',
                    style: TextStyle(fontSize: 24),
                  ),
                  RaisedButton(
                      child: Text('Sign Out Google'),
                      onPressed: () {
                        try {
                          model.googleWithSignOut(context);
                        } catch (e) {
                          return null;
                        }
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
