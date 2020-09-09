import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/next/next_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextPage extends StatelessWidget {
  NextPage(User user, BuildContext context);

  @override
  Widget build(BuildContext context) {
    User userData;
    return ChangeNotifierProvider<NextModel>(
      create: (_) => NextModel(userData),
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
                  Image.network('${model.photoURL}'),
                  Text(
                    '${model.name}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${model.email}',
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
