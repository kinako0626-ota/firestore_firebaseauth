import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/chat/chatpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  //TODO:login

  Future<User> login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    try {
      final User mailUser =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail,
        password: password,
      ))
              .user;
      return mailUser;
    } catch (e) {
      throw (_convertErrorMessage(e.code));
    }
  }

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
  nextPage(user, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  user,
                )));
    notifyListeners();
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください';
    case 'wrong-password':
      return 'パスワードが間違っています';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'user-disabled':
      return 'ユーザーが無効です';
    default:
      return '不明なエラーです';
  }
}
