import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:topit_tut/models/user.dart' as model;
import 'package:topit_tut/views/screens/auth/login.screen.dart';
import 'package:topit_tut/views/screens/home.screen.dart';

import '../constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;


  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
    super.onReady();
  }

  _setInitialScreen(User? user) {
    if(user == null) {
      Get.offAll(()=>LoginScreen());
    } else {
      Get.offAll(()=>const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage!=null) {
      Get.snackbar("Profile Picture", "You have successfully selected profile picture");
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  void registerUser(
      String userName, String email, String password, File? image) async {
    try {
      if (userName.isNotEmpty && email.isNotEmpty && image != null) {
        //save user
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
            name: userName,
            profilePhoto: downloadUrl,
            email: email,
            uid: cred.user!.uid);
        saveUser(user, cred);
      } else {
        Get.snackbar("Error Creating Account", "Please provide all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString());
    }
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask task = ref.putFile(image);
    TaskSnapshot snap = await task;
    return await snap.ref.getDownloadURL();
  }

  void saveUser(model.User user, UserCredential cred) async {
    await firebaseStore
        .collection('users')
        .doc(cred.user!.uid)
        .set(user.toJson());
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar("Error Creating Account", "Please provide all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString());
    }
  }
}
