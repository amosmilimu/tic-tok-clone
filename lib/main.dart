import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:topit_tut/constants.dart';
import 'package:topit_tut/controllers/auth.controller.dart';
import 'package:topit_tut/views/screens/auth/login.screen.dart';
import 'package:topit_tut/views/screens/auth/signup.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value){
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Topit',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backGroundColor
      ),
      home: SignUpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
