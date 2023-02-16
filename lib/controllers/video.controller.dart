import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';
import 'package:topit_tut/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    _videoList.bindStream(firebaseStore.collection('videos').snapshots().map((QuerySnapshot querySnapshot){
      List<Video> reVal = [];

      for(var element in querySnapshot.docs) {
        reVal.add(Video.fromSnap(element));
      }
      return reVal;
    }));
    super.onInit();
  }
}