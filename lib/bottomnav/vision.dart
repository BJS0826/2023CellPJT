import 'package:flutter/material.dart';

class VisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("앱 비전"),
        leading: BackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "우리 앱의 비전은 사용자에게 최고의 경험을 제공하는 것입니다!",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Image.asset("assets/logo.png"),
            SizedBox(height: 16),
            Text(
              "세부 비전",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "- 사용자 중심의 인터페이스 제공",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "- 직관적이고 쉬운 사용성",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
