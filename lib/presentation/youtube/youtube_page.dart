import 'package:firestore_firebaseauth/domain/video.dart';
import 'package:firestore_firebaseauth/presentation/youtube/youtube_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YoutubePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<YoutubeModel>(
      create: (_) => YoutubeModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('動画リスト'),
        ),
        body: Consumer<YoutubeModel>(
          builder: (context, model, child) => model.channel != null
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!model.isLoading &&
                        model.channel.videos.length !=
                            int.parse(model.channel.videoCount) &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      model.loadMoreVideos();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: 1 + model.channel.videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return model.buildProfileInfo();
                      }
                      Video video = model.channel.videos[index - 1];
                      return model.buildVideo(video, context);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor, // Red
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
