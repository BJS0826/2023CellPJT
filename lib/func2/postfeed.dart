import 'package:cellpjt/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/func2/members.dart';

class PostFeedPage extends StatefulWidget {
  @override
  _PostFeedPageState createState() => _PostFeedPageState();
}

class _PostFeedPageState extends State<PostFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 17.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              const Text('피드 작성'),
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
      body: ListView(padding: EdgeInsets.all(16.0), children: [
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
                      builder: (context) => MembersPage()), // 모임원 페이지로 이동
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
                          style: TextStyle(color: Colors.black, fontSize: 9.0),
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
                          style: TextStyle(color: Colors.black, fontSize: 9.0),
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
                          style: TextStyle(color: Colors.black, fontSize: 9.0),
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
                          style: TextStyle(color: Colors.black, fontSize: 9.0),
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Image.asset(
                  'assets/icon_postfeed.png', // 원 안에 들어갈 이미지 경로
                  height: 30.0,
                  width: 30.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // 신규 피드 페이지 연결
                        },
                        icon: Icon(Icons.add),
                      ),
                      Text('신규 피드'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // 포인트 상점 페이지 연결
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
                      Text('포인트 상점'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // 설정 페이지 연결
                        },
                        icon: Icon(Icons.settings),
                      ),
                      Text('설정'),
                    ],
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
        ]),
      ]),
    );
  }
}
