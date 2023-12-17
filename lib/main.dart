import 'package:cellpjt/firebase_options.dart';
import 'package:cellpjt/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/func1/login.dart';
import 'package:cellpjt/bottomnav/mainfeed.dart';
import 'package:cellpjt/bottomnav/grouplist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = DefaultFirebaseOptions.currentPlatform;

  // Firebase 앱을 초기화합니다.
  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱의 초기 화면을 지정
      home: LoginPage(),
    );
  }
}
