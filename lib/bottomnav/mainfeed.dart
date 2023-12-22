import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/func2/aboutgroup.dart';
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

  int _currentIndex = 0;

  bool _isExpanded = false;

  bool _showCommentPopup = false;
  TextEditingController _commentController = TextEditingController();
  List<String> _comments = ['댓글 1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildFeedList(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
        buildAppBarIconButton(Icons.search, () {
          // 검색 버튼 페이지 연결
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupSearchPage()),
          );
        }),
        buildAppBarIconButton(Icons.add, () {
          // 글 작성 버튼 페이지 연결
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupPage()),
          );
        }),
        buildAppBarIconButton(Icons.notifications, () {
          // 알림 페이지 연결
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationPage()),
          );
        }),
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
    );
  }

  IconButton buildAppBarIconButton(IconData icon, Function onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed as void Function()?,
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 8.0), // 패딩 조절
    );
  }

  ListView buildFeedList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return buildFeedItem();
      },
    );
  }

  Card buildFeedItem() {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: buildCircleAvatar(),
            title: Text('강현규'),
            subtitle: Text('3시간 전', style: TextStyle(color: Colors.grey)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutGroupPage()),
              );
            },
            child: buildPostImage(),
          ),
          buildLikeRow(),
          buildFeedContent(),
          buildCommentButton(),
          buildCommentPopup(),
        ],
      ),
    );
  }

  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      radius: 20.0,
      backgroundImage: AssetImage('assets/profile_image.jpg'),
    );
  }

  Image buildPostImage() {
    return Image.asset(
      'assets/post_image.jpg',
      fit: BoxFit.cover,
      height: 200.0,
    );
  }

  Row buildLikeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildLikeButton(),
        TextButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(_isExpanded ? '접기' : '더보기'),
        ),
      ],
    );
  }

  Row buildLikeButton() {
    return Row(
      children: [
        IconButton(
          icon: _isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
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
        Text('$_likeCount', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget buildCommentButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.insert_comment),
            onPressed: () {
              setState(() {
                _showCommentPopup = true;
              });
            },
          ),
          Text('댓글 달기', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildFeedContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '안녕하세요. 지난 6월 스페인 산티아고로 순례를 다녀왔습니다. 위 사진은 순례길을 걷던 중 자연 풍경이 아름다워 찍은 사진입니다. 아직 산티아고 순례길에 가보지 못한 분들이 계시다면 꼭 한번 가보셨으면 좋겠습니다. 감사합니다.',
            style: TextStyle(fontSize: 16.0),
            maxLines: _isExpanded ? null : 3,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.0),
          Text(
            '#경기 남부 #여행',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget buildCommentPopup() {
    return Visibility(
      visible: _showCommentPopup,
      child: Container(
        color: Colors.black26,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '댓글',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              buildCommentList(),
              SizedBox(height: 16.0),
              buildCommentInput(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showCommentPopup = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFF6F61),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('닫기'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 댓글 등록 기능 추가
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFF6F61),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('등록'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommentList() {
    return Container(
      height: 100.0, // 적절한 높이 설정
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_comments[index]),
          );
        },
      ),
    );
  }

  Widget buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: '댓글을 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
