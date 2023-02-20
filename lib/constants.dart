import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:topit_tut/controllers/auth.controller.dart';
import 'package:topit_tut/views/screens/add.video.screen.dart';
import 'package:topit_tut/views/screens/video.screen.dart';


List pages = [
  VideoScreen(),
  const Text('Search Screen'),
  const AddVideoScreen(),
  const Text('Messages Screen'),
  const Text('Profile Screen')
];

const backGroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebaseStore = FirebaseFirestore.instance;

//controller
var authController = AuthController.instance;