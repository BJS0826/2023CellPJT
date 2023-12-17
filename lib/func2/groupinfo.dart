import 'package:flutter/material.dart';

class GroupInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(top: 20),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 18.0, right: 20.0),
          child: Row(
            children: [
              SizedBox(width: 8.0),
              const Text('모임 정보'),
            ],
          ),
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
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
          // 1번째 열 - '모임명'
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '모임명',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 2번째 열 - '구로 독서 모임 1기'
          ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 4.0,
                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.2), width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('구로 독서 모임 1기'),
            ),
          ),
          // 3번째 열 - '모임소개'
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '모임소개',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 4번째 열 - '독서 습관을 만드는 모임'
          ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 4.0,
                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.2), width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('독서 습관을 만드는 모임'),
            ),
          ),
          // 5번째 열 - '관심사'
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '관심사',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 6번째 열 - 투명한 회색 사각형 배경에 '독서'
          ListTile(
            title: Container(
              color: Colors.grey.withOpacity(0.2),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 4.0,
                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
              child: Text('독서'),
            ),
          ),
          // 7번째 열 - '지역'
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '지역',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 8번째 열 - 투명한 회색 사각형 배경에 '서울'
          ListTile(
            title: Container(
              color: Colors.grey.withOpacity(0.2),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 4.0,
                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
              child: Text('서울'),
            ),
          ),
          // 9번째 열 - '모임 인원'
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '모임 인원',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 10번째 열 - '20 / 50'
          ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 4.0,
                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.2), width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('20 / 50'),
            ),
          ),
          // 11번째 열 - 투명한 회색 글씨로 '(현재 / 전체)'
          ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 4.0,
                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
              child: Text('(현재 / 전체)', style: TextStyle(color: Colors.grey)),
            ),
          ),
          SizedBox(height: 16.0),
          // 나머지 페이지 내용 추가
          // ...
        ],
      ),
    );
  }
}
