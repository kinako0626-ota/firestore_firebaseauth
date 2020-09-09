import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book(DocumentSnapshot doc) {
    //
    docId = doc.id;
    title = doc.data()['title'];
  }

  String docId;
  String title;
}
