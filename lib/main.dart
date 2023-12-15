import 'package:flutter/material.dart';
import 'package:cellpjt/func1/login.dart'; // 대상 화면의 파일을 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      initialRoute: '/', // 시작 화면의 라우트를 지정
      routes: {
        '/': (context) => LoginPage() // 시작 화면
      },
    );
  }
}
