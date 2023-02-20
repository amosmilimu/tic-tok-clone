import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';
import 'package:topit_tut/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    _videoList.bindStream(firebaseStore.collection('video').snapshots().map((QuerySnapshot querySnapshot){
      List<Video> reVal = [];

      for(var element in querySnapshot.docs) {
        reVal.add(Video.fromSnap(element));
      }
      return reVal;
    }));
    super.onInit();
  }
  
  likeVideo(String id) async {
    DocumentSnapshot snapshot = await firebaseStore.collection('video').doc(id).get();
    var uid = authController.user.uid;
    if((snapshot.data() as dynamic)['likes'].contains(uid)) {
      await firebaseStore.collection('video').doc(id).update({
        'likes':FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseStore.collection('video').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
  
}