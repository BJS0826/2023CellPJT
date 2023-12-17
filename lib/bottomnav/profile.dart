import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '셀모임',
      home: Scaffold(
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
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // 검색 버튼 페이지 연결
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // 글 작성 버튼 페이지 연결
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateGroupPage()),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // 알림 버튼 페이지 연결
                },
              ),
            ),
          ],
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
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '추천 정모',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 전체 보기 버튼 페이지 연결
                  },
                  child: Text('전체 보기'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // 이미지가 포함된 카드 형태의 정모 소개 박스
            Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 정모 이미지
                  Image.asset(
                    'assets/meeting_image.jpg',
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '정모명 및 날짜',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // 가로 4개 * 세로 2줄의 버튼 그리드
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('전체보기')),
                ElevatedButton(onPressed: () {}, child: Text('독서')),
                ElevatedButton(onPressed: () {}, child: Text('경제')),
                ElevatedButton(onPressed: () {}, child: Text('예술')),
                ElevatedButton(onPressed: () {}, child: Text('음악')),
                ElevatedButton(onPressed: () {}, child: Text('운동')),
                ElevatedButton(onPressed: () {}, child: Text('직무')),
                ElevatedButton(onPressed: () {}, child: Text('자유')),
              ],
            ),
            SizedBox(height: 16.0),
            // 모임명과 모임 설명이 나열되는 리스트뷰
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 2.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                AssetImage('assets/profile_image.jpg'),
                          ),
                          title: Text('모임명'),
                          subtitle: Text('모임 설명',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(ProfilePage());
}
