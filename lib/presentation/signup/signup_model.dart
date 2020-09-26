import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebaseauth/presentation/chat/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpModel extends ChangeNotifier {
  //TODO:空の変数用意(メール、パスワード)
  String mail = '';
  String password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      //TODO:userIDを格納
      final uId = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('user')
          .add(
        {
          'userID': user.uid,
          'userName': user.displayName,
          'userPhotoURL': user.photoURL,
          'created_at': Timestamp.now(),
        },
      );
      notifyListeners();

//TODO:user情報を返す
      return user;
    } catch (e) {
      notifyListeners();
      return null;
    }
  }

//TODO:認証
  Future<User> signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    final User mailPassUser = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    ))
        .user;
    final uId = mailPassUser.uid;
    final email = mailPassUser.email;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('user')
        .add({
      'mail_address': email,
      'created_at': Timestamp.now(),
    });
    notifyListeners();
    return mailPassUser;
  }

  signUpPage(mailPassUser, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(mailPassUser),
      ),
    );
    notifyListeners();
  }

  nextPage(user, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(user),
      ),
    );
    notifyListeners();
  }
}
