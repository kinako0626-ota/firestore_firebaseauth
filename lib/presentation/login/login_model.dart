import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/next/nextpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {
  //TODO; Google SignIn
  Future<User> signInWithGoogle() async {
    try {
      //TODO:認証フローのトリガー
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      //TODO:ユーザー認証の詳細をリクエストから取得
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      //TODO:新しいユーザー認証情報を作成
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //TODO:サインイン完了後UserCredential情報をuserに入れる

      final User user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      notifyListeners();

//TODO:user情報を返す
      return user;
    } catch (e) {
      notifyListeners();
      return null;
    }
  }

  //TODO:遷移先に取得したuserを渡す
  nextPage(User user, BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => NextPage(user, context)));
    notifyListeners();
  }
}
