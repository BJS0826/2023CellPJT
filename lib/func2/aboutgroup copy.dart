import 'package:cellpjt/func2/members.dart';
import 'package:cellpjt/home_page.dart';
import 'package:flutter/material.dart';

class AboutGroupPage extends StatefulWidget {
  @override
  _AboutGroupPageState createState() => _AboutGroupPageState();
}

class _AboutGroupPageState extends State<AboutGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 17.0),
          child: Row(
            children: [
              SizedBox(width: 8.0),
              const Text('모임 소개'),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // 높이 조절
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '모임명',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembersPage(),
                    ), // 모임원 페이지로 이동
                  );
                },
                child: Text(
                  '모임원 >',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 모임 정보 페이지 연결
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // 배경 색상 변경
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        minimumSize: Size(0, 80),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icon_info.png',
                            height: 30.0,
                            width: 30.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '모임 정보',
                            style:
                                TextStyle(color: Colors.black, fontSize: 9.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 정모 일정 페이지 연결
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        minimumSize: Size(0, 80),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icon_schedule.png',
                            height: 30.0,
                            width: 30.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '정모 일정',
                            style:
                                TextStyle(color: Colors.black, fontSize: 9.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 게시판 페이지 연결
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        minimumSize: Size(0, 80),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icon_board.png',
                            height: 30.0,
                            width: 30.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '게시판',
                            style:
                                TextStyle(color: Colors.black, fontSize: 9.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 단체채팅 페이지 연결
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        minimumSize: Size(0, 80),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icon_chat.png',
                            height: 30.0,
                            width: 30.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '단체채팅',
                            style:
                                TextStyle(color: Colors.black, fontSize: 9.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              4,
              (index) => Card(
                elevation: 2.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/post_image.jpg',
                      fit: BoxFit.cover,
                      height: 100.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '피드 제목',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
