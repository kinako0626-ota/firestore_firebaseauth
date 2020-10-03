import 'package:firestore_firebaseauth/domain/channel.dart';
import 'package:firestore_firebaseauth/domain/video.dart';
import 'package:firestore_firebaseauth/utilities/keys.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String _baseURL = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> ios_parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': IOS_API_KEY,
    };
    Uri ios_uri = Uri.https(
      _baseURL,
      '/youtube/v3/channels',
      ios_parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var ios_response = await http.get(ios_uri, headers: headers);
    if (ios_response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(ios_response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(ios_response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': IOS_API_KEY,
    };
    Uri uri = Uri.https(
      _baseURL,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
