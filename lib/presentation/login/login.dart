import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/chat/chatpage.dart';
import 'package:firestore_firebaseauth/presentation/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';

class Login extends StatelessWidget {
  final User user;

  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  Login({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SignInButtonBuilder(
                          text: 'ログイン',
                          icon: Icons.email,
                          onPressed: () async {
                            //TODO:try{}catch{}とすることでtryには成功したときの処理、catchには失敗したときの処理が走る
                            try {
                              //TODO:
                              await model.login();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(this.user),
                                    fullscreenDialog: true,
                                  ));
                            } catch (e) {
                              //TODO:
                              _showDialog(context, e.toString());
                            }
                            await model.login();
                          },
                          backgroundColor: Colors.blueGrey[700],
                          width: 220.0,
                        ),
                      ),
                      Divider(),
                      SignInButton(
                        Buttons.GoogleDark,
                        text: 'Googleでログイン',
                        onPressed: () async {
                          try {
                            User user = await model.signInWithGoogle();
                            if (user == null) {
                              return null;
                            } else {
                              await model.nextPage(user, context);
                            }
                          } catch (e) {
                            return null;
                          }
                        },
                      ),
                      Divider(),
                      Container(
                        child: Text('新規登録はこちらから'),
                      ),
                      Divider(),
                      SignInButton(
                        Buttons.Email,
                        text: '新規会員登録',
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            );
          },
        ),
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
