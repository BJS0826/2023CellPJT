import 'package:cellpjt/appbar/notification.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
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
                  // 글 작성 버튼 페이지 연결
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // 흰색 배경색
                    onPrimary: Colors.black, // 흰색 배경에 검은색 텍스트
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // 모서리를 둥근 네모로 만듦
                    ),
                  ),
                  child: Text(
                    '전체 보기',
                    style: TextStyle(color: Colors.black), // 텍스트 색상
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0), // 버튼 간격을 조절
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
              mainAxisSpacing: 8.0, // 버튼 간격을 조절
              crossAxisSpacing: 8.0, // 버튼 간격을 조절
              shrinkWrap: true,
              children: [
                _buildCategoryButton('전체보기', 'assets/category_all.png'),
                _buildCategoryButton('독서', 'assets/category_reading.png'),
                _buildCategoryButton('경제', 'assets/category_economy.png'),
                _buildCategoryButton('예술', 'assets/category_art.png'),
                _buildCategoryButton('음악', 'assets/category_music.png'),
                _buildCategoryButton('운동', 'assets/category_sports.png'),
                _buildCategoryButton('직무', 'assets/category_career.png'),
                _buildCategoryButton('자유', 'assets/category_free.png'),
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

  // 수정된 함수 추가
  Widget _buildCategoryButton(String text, String imagePath) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // 해당 카테고리로 이동하는 로직 추가
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // 흰색 배경색
            onPrimary: Colors.black, // 흰색 배경에 검은색 텍스트
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // 모서리를 둥근 네모로 만듦
            ),
          ),
          child: Container(
            width: 20.0, // 이미지 너비 조정
            height: 20.0, // 이미지 높이 조정
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.0), // 텍스트와 버튼 사이의 간격 조절
        Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}
