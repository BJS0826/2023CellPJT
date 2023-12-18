import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/func2/aboutgroup.dart';
import 'package:cellpjt/func2/members.dart';
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutGroupPage()));
                      },
                      child: Image.asset(
                        'assets/post_image.jpg',
                        fit: BoxFit.cover,
                        height: 200.0,
                      ),
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
      ),
    );
  }
}

void main() {
  runApp(MainFeedPage());
}
