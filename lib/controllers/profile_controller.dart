import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updatedUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  void getUserData() async {
    List<String> thumbNails = [];
    var myVids = await firebaseStore.collection('video')
    .where('uid', isEqualTo: _uid.value).get();

    for(int i = 0; i < myVids.docs.length; i++) {
      thumbNails.add((myVids.docs[i].data() as dynamic)['thumbNail']);
    }

    DocumentSnapshot userDocument = await firebaseStore.collection('users')
    .doc(_uid.value).get();

    final data = userDocument.data() as dynamic;

    String name = data['name'];
    String profilePhoto = data['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int followings = 0;
    bool isFollowing = false;

    for(var item in myVids.docs) {
      likes+=(item.data()['likes'] as List).length;
    }

    var followerDoc = await firebaseStore.collection('users').doc(_uid.value)
    .collection('followers').get();

    var followingDoc = await firebaseStore.collection('users').doc(_uid.value)
        .collection('followings').get();

    followers = followerDoc.docs.length;
    followings = followingDoc.docs.length;

    firebaseStore.collection('users').doc(_uid.value).collection('followers')
    .doc(authController.user.uid).get().then((value){
      if(value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': followings.toString(),
      'isFollowing': isFollowing,
      'likes':likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbNails
    };

    update();
  }

}