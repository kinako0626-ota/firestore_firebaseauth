import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/chat/chatpage.dart';
import 'package:firestore_firebaseauth/presentation/signup/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  final User user;
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  SignUpPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('会員登録'),
        ),
        body: Consumer<SignUpModel>(builder: (context, model, child) {
          return Padding(
              padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
              child: Column(children: <Widget>[
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(
                    hintText: 'example@sample.com',
                  ),
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'パスワードを入力してください',
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SignInButtonBuilder(
                    text: 'Get going with Email',
                    icon: Icons.email,
                    onPressed: () async {
                      //TODO:try{}catch{}とすることでtryには成功したときの処理、catchには失敗したときの処理が走る
                      try {
                        //TODO:
                        await model.signUp();
                        _showDialog(context, '登録完了しました');
                      } catch (e) {
                        //TODO:
                        _showDialog(context, e.toString());
                      }
                      await model.signUp();
                    },
                    backgroundColor: Colors.blueGrey[700],
                    width: 220.0,
                  ),
                ),
                Divider(),
                SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () {
                    _showButtonPressDialog(context, 'Google (dark)');
                  },
                ),
                Divider(),
                SignInButton(
                  Buttons.Apple,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(user)));
                  },
                ),
                Divider(),
              ]));
        }),
      ),
    );
  }
}

Future _showDialog(BuildContext context, String title) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showButtonPressDialog(BuildContext context, String provider) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('$provider Button Pressed!'),
    backgroundColor: Colors.black26,
    duration: Duration(milliseconds: 400),
  ));
}
