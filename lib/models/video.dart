import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String userName;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String thumbNail;
  String videoUrl;
  String profilePhoto;

  Video({
    required this.userName,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.thumbNail,
    required this.videoUrl,
    required this.profilePhoto
  });

  Map<String, dynamic> toJson() =>
      {
        "userName": userName,
        "uid": uid,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "thumbNail": thumbNail,
        "videoUrl": videoUrl,
        "profilePhoto": profilePhoto
      };

  static Video fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Video(userName: data['userNName'],
        uid: data['uid'],
        id: data['id'],
        likes: data['likes'],
        commentCount: data['commentCount'],
        shareCount: data['shareCount'],
        songName: data['songName'],
        caption: data['caption'],
        thumbNail: data['thumbNail'],
        videoUrl: data['videoUrl'],
        profilePhoto: data['profilePhoto']);
  }
}