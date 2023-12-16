import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';
import 'package:cellpjt/appbar/groupsearch.dart';

class MainFeedPage extends StatefulWidget {
  @override
  _MainFeedPageState createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  bool _isLiked = false;
  int _likeCount = 0;

  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupSearchPage()),
                  );
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
        body: ListView.builder(
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
                        backgroundImage: AssetImage('assets/profile_image.jpg'),
                      ),
                      title: Text('강현규'),
                      subtitle:
                          Text('3시간 전', style: TextStyle(color: Colors.grey)),
                    ),
                    Image.asset(
                      'assets/post_image.jpg',
                      fit: BoxFit.cover,
                      height: 200.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '피드 내용',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '#경기 남부 #여행',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: _isLiked
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              onPressed: () {
                                setState(() {
                                  if (_isLiked) {
                                    _isLiked = false;
                                    _likeCount--;
                                  } else {
                                    _isLiked = true;
                                    _likeCount++;
                                  }
                                });
                              },
                            ),
                            SizedBox(width: 4.0),
                            Text('$_likeCount',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // 현재 인덱스 업데이트

              switch (index) {
                case 0:
                  // 현재 페이지로 이동 (MainFeedPage)
                  break;
                case 1:
                  // '/grouplist' 경로로 이동
                  Navigator.pushNamed(context, '/grouplist');
                  break;
                case 2:
                  print('채팅 페이지');
                  break;
                case 3:
                  print('프로필 페이지');
                  break;
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: '모임',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '프로필',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MainFeedPage());
}
