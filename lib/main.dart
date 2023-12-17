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
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱의 초기 화면을 지정
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
