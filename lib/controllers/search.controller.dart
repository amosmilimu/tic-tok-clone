import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';
import 'package:topit_tut/models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typeUser) async {
    _searchedUsers.bindStream(firebaseStore.collection('users')
        .where('name', isGreaterThanOrEqualTo: typeUser).snapshots().map((QuerySnapshot query){
          List<User> retVal = [];

          for(var elem in query.docs) {
            retVal.add(User.fromSnap(elem));
          }

          return retVal;
    }));
  }

}