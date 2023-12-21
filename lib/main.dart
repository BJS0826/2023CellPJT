import 'package:cellpjt/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/func1/login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = DefaultFirebaseOptions.currentPlatform;

  // Firebase 앱을 초기화합니다.
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    // 2초 후에 첫 화면으로 이동
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyAppBody()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 인트로 페이지 UI
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 지정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/intro_image.jpg', // 이미지 파일 경로 설정
              width: 300, // 이미지 너비
              height: 300, // 이미지 높이
            ),
            SizedBox(height: 20), // 이미지와 텍스트 사이의 간격 조절
            Text(
              '셀모임',
              style: TextStyle(
                fontSize: 45, // 텍스트 크기 조절
                fontWeight: FontWeight.bold, // 텍스트 굵기 조절
                color: Colors.black, // 텍스트 색상 조절
              ),
            ),
            SizedBox(height: 20), // 텍스트와 CircularProgressIndicator 사이의 간격 조절
            CircularProgressIndicator(
              color: Colors.white, // CircularProgressIndicator 색상 지정
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppBody extends StatelessWidget {
  const MyAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
