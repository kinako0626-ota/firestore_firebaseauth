import 'package:firestore_firebaseauth/presentation/youtube/youtube_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YoutubePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<YoutubeModel>(
      create: (_) => YoutubeModel()..initChannel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('動画リスト'),
        ),
        body: Consumer<YoutubeModel>(
          builder: (context, model, child) {
            return model.build(context);
          },
        ),
      ),
    );
  }
}
