import 'package:cellpjt/func1/signup.dart';
import 'package:cellpjt/bottomnav/mainfeed.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cellpjt/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailNode = FocusNode();
  final FocusNode _pwNode = FocusNode();
  final TextEditingController _emailLogin = TextEditingController();
  final TextEditingController _pwLogin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 17.0),
          child: const Text('셀모임'),
        ),
        leading: Container(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.0), // 아래쪽에 패딩을 추가
              child: Text(
                '셀모임에 오신 것을 환영합니다!',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '이메일',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextFormField(
                    key: ValueKey(1),
                    controller: _emailLogin,
                    focusNode: _emailNode,
                    validator: (value) {
                      if (value!.length < 6 ||
                          !value.contains("@") ||
                          !value.contains(".")) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("이메일을 확인해 주세요"),
                          backgroundColor: Colors.blue,
                        ));
                        _emailNode.requestFocus();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: '이메일을 입력하세요.',
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0), // 여백을 조절
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '비밀번호',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextFormField(
                    key: ValueKey(2),
                    controller: _pwLogin,
                    focusNode: _pwNode,
                    validator: (value) {
                      if (value!.length < 7) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("비밀번호를 확인해 주세요. 비밀번호는 최소 7자 입니다."),
                          backgroundColor: Colors.blue,
                        ));
                        _pwNode.requestFocus();
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호를 입력하세요.',
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6F61), // 헥사 코드 #FF6F61 (코랄 핑크)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),

                        onPrimary: Colors.white, // 텍스트 색상을 흰색으로 지정
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await _auth.signInWithEmailAndPassword(
                                email: _emailLogin.text,
                                password: _pwLogin.text);

                            if (context.mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("로그인을 실패했습니다"),
                                backgroundColor: Colors.blue,
                              ));
                            }
                          }
                        }
                      },
                      child: Text('로그인'),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6F61), // 헥사 코드 #FF6F61 (코랄 핑크)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPrimary: Colors.white, // 텍스트 색상을 흰색으로 지정
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text('회원가입'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
