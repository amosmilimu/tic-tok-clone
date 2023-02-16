import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';
import 'package:topit_tut/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  //upload video

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await firebaseStore.collection('users').doc(
          uid).get();
      //get id
      var allDocs = await firebaseStore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbNailUrl = await _uploadImageToStorage(
          "Video $len", videoPath);

      Video video = Video(
          userName: (userDoc.data() as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          thumbNail: thumbNailUrl,
          videoUrl: videoUrl,
          profilePhoto: (userDoc.data() as Map<String,
              dynamic>)['profilePhoto']);

      await firebaseStore.collection('video').doc('Video $len')
      .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar("Error uploading video", e.toString());
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref('video').child(id);
    UploadTask task = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await task;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
        videoPath, quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }
}

Future<String> _uploadImageToStorage(String id, String videoPath) async {
  Reference ref = firebaseStorage.ref('thumbNails').child(id);
  UploadTask task = ref.putFile(await _getThumbNail(videoPath));
  TaskSnapshot snap = await task;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
}

_getThumbNail(String videoPath) async {
  final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
  return thumbNail;
}