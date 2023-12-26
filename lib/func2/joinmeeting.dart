import 'package:flutter/material.dart';

class JoinMeetingPage extends StatelessWidget {
  TextEditingController greetingController =
      TextEditingController(); // 가입인사를 위한 컨트롤러 추가

  JoinMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모임 가입',
      home: Scaffold(
        appBar: AppBar(
          title: Text('모임 가입'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '가입인사',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              TextField(
                controller: greetingController,
                maxLines: 3, // 가입인사를 위해 여러 줄 입력 가능하도록 설정
                decoration: InputDecoration(
                  hintText: '가입인사를 작성하세요.',
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFF6F61), // 코랄 핑크
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPrimary: Colors.white, // 텍스트 색상
                        ),
                        onPressed: () {
                          // 모임 가입 버튼
                          _joinMeeting(context);
                        },
                        child: Text('모임 가입'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinMeeting(BuildContext context) {
    // 여기에 모임 가입 로직을 추가하세요.
    // 가입인사 등을 활용하여 모임 가입을 처리할 수 있습니다.
    // 예를 들면, 서버에 가입 요청을 보내거나 다른 필요한 작업을 수행할 수 있습니다.
    // 가입이 성공하면 다음 화면으로 이동하는 등의 처리를 할 수 있습니다.
    // 예시로 Navigator.push() 등을 사용하여 다음 화면으로 이동할 수 있습니다.
  }
}
