import 'package:cloud_firestore/cloud_firestore.dart';

class ChatEntry {
  ChatEntry(DocumentSnapshot doc) {
    documentID = doc.id;
    text = doc.data()['text'];
    userName = doc.data()['userName'];
    userPhotoURL = doc.data()['userPhotoURL'];
    userEmail = doc.data()['userEmail'];
  }
  String documentID;
  String text;
  String userName;
  String userPhotoURL;
  String userEmail;
}
