import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';

class Login extends StatelessWidget {
  final User user;
  const Login({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google 認証練習'),
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Sign in Google'),
                      onPressed: () async {
                        try {
                          User user = await model.signInWithGoogle();

                          await model.nextPage(user, context);
                        } catch (e) {
                          return null;
                        }
                      },
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
