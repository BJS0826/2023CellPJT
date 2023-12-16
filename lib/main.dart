import 'package:cellpjt/firebase_options.dart';
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
      title: 'Your App',
      initialRoute: '/', // 시작 화면의 라우트를 지정
      routes: {
        '/': (context) => LoginPage(), // 시작 화면
        '/home': (context) => MainFeedPage(), // 홈 화면
        '/grouplist': (context) => GroupListPage(), // 설정 화면
        // 다른 페이지들을 필요에 따라 추가
      },
    );
  }
}
