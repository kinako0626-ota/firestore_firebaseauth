import 'package:firestore_firebaseauth/api_services/api_service.dart';
import 'package:firestore_firebaseauth/domain/channel.dart';
import 'package:firestore_firebaseauth/domain/video.dart';
import 'package:firestore_firebaseauth/presentation/video_screen/video_screen_page.dart';
import 'package:flutter/material.dart';

class YoutubeModel extends ChangeNotifier {
  Channel channel;
  bool isLoading = false;

  //Channel情報を取得
  initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCRsMziob9fkdoQYlkBbclGA');
    this.channel = channel;
    notifyListeners();
  }

  buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(channel.profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  channel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'チャンネル登録者数${channel.subscriberCount} 人',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildVideo(Video video, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadMoreVideos() async {
    isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId);
    List<Video> allVideos = channel.videos..addAll(moreVideos);
    channel.videos = allVideos;
    notifyListeners();
    isLoading = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!isLoading &&
                    channel.videos.length != int.parse(channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: 1 + channel.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return buildProfileInfo();
                  }
                  Video video = channel.videos[index - 1];
                  return buildVideo(video, context);
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
    );
  }
}
