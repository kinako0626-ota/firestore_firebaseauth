import 'package:firestore_firebaseauth/presentation/book_list/book_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('練習'),
        ),
        body: Container(
          child: Consumer<BookListModel>(
            builder: (context, model, child) {
              final books = model.books;
              final listTiles = books
                  .map((book) => ListTile(
                        title: Text(book.title),
                      ))
                  .toList();
              return ListView(
                children: listTiles,
              );
            },
          ),
        ),
      ),
    );
  }
}
