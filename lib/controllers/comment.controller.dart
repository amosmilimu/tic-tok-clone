import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';

import '../models/comments.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComments();
  }

  getComments() async {
    _comments.bindStream(firebaseStore.collection('video').doc(_postId).collection('comments').snapshots().map((QuerySnapshot querySnapshot)
    {
      List<Comment> retValue = [];
      for(var elem in querySnapshot.docs) {
        retValue.add(Comment.fromSnap(elem));
      }
      return retValue;
    }));
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firebaseStore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await firebaseStore
            .collection('video')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
            username: (userDoc.data() as dynamic)['name'],
            comment: commentText.trim(),
            datePublished: DateTime.now(),
            likes: [],
            profilePhoto: (userDoc.data() as dynamic)['profilePhoto'],
            uid: authController.user.uid,
            id: 'Comment $len');

        await firebaseStore
            .collection('video')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());

        DocumentSnapshot snapshot = await firebaseStore.collection('video').doc(_postId).get();
        await firebaseStore.collection('video').doc(_postId).update({
          'commentCount':(snapshot.data() as dynamic)['commentCount'] + 1
        });

      }
    } catch(e) {
      Get.snackbar("Error while commenting", e.toString());
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firebaseStore.collection('video')
    .doc(_postId).collection('comments').doc(id).get();
    if((doc.data() as dynamic)['likes'].contains(uid)) {
      await firebaseStore.collection('video').doc(_postId)
          .collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseStore.collection('video').doc(_postId)
          .collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
