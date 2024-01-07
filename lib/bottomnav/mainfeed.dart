import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/func2/aboutgroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';
import 'package:cellpjt/appbar/groupsearch.dart';

class MainFeedPage extends StatefulWidget {
  @override
  _MainFeedPageState createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  int _likeCount = 0;

  bool _isExpanded = false;

  bool _showCommentPopup = false;
  TextEditingController _commentController = TextEditingController();
  List<String> _comments = ['댓글 1'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  late List<DocumentSnapshot> _data = [];
  bool _isLoading = false;
  int _perPage = 10; // 한 번에 가져올 아이템 수
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _getInitialData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  Future<void> _getInitialData() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('feed')
        .orderBy('time', descending: true)
        .limit(_perPage)
        .get();

    setState(() {
      _data = querySnapshot.docs;
      _isLoading = false;
    });
  }

  Future<void> _getMoreData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      DocumentSnapshot lastDocument = _data[_data.length - 1];
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('feed')
          .orderBy('time')
          .startAfterDocument(lastDocument)
          .limit(_perPage)
          .get();

      setState(() {
        _data.addAll(querySnapshot.docs);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _data.length + 1,
        itemBuilder: (context, index) {
          if (index == _data.length) {
            return Center(child: _buildLoader());
          } else {
            String feedContent = _data[index]['feedContent'];
            Map<String, dynamic> preName = _data[index]['writer'];
            String name = preName.values.first.toString();
            String feedID = _data[index].id;

            String feedImage = _data[index]['feedImage'];
            String moimId = _data[index]['moimId'];

            print(feedID);
            return FutureBuilder(
                future: _firestore.collection('Moim').doc(moimId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('데이터를 불러올 수 없습니다.'),
                      );
                    } else {
                      final moimData = snapshot.data!;
                      String moimTitle = moimData['moimTitle'];
                      String moimImage = moimData['moimImage'];

                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutGroupPage(
                                            moimID: moimData.id,
                                          )),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(moimImage),
                                ),
                                title: Text(moimTitle),
                                subtitle: Text(name,
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AboutGroupPage(
                                              moimID: moimData.id,
                                            )),
                                  );
                                },
                                child: Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(feedImage))),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Row(
                                //   children: [
                                //     IconButton(
                                //       icon: favorite.isNotEmpty
                                //           ? Icon(Icons.favorite)
                                //           : Icon(Icons.favorite_border),
                                //       onPressed: () async {
                                //         await _firestore
                                //             .collection('feed')
                                //             .doc(feedID)
                                //             .update({
                                //           "favorite": [user!.uid]
                                //         });

                                //         setState(() {});
                                //       },
                                //     ),
                                //     SizedBox(width: 4.0),
                                //     Text('${favorite.length}',
                                //         style: TextStyle(color: Colors.grey)),
                                //   ],
                                // ),
                                // TextButton(
                                //   onPressed: () {
                                //     setState(() {
                                //       _isExpanded = !_isExpanded;
                                //     });
                                //   },
                                //   child: Text(_isExpanded ? '접기' : '더보기'),
                                // ),
                              ],
                            ),
                            buildFeedContent(feedContent),
                            // buildCommentButton(),
                            // buildCommentPopup(),
                          ],
                        ),
                      );
                    }
                  }
                });
          }
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: 17.0),
        child: const Text('셀모임'),
      ),
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
          ),
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
        buildAppBarIconButton(Icons.notifications_none, () {
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

  Widget _buildLoader() {
    return _isLoading ? CircularProgressIndicator() : Container();
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

  Widget buildFeedContent(String feedContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            feedContent,
            style: TextStyle(fontSize: 16.0),
            maxLines: _isExpanded ? null : 3,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.0),
          // 해쉬태그 잠시 중지
          // Text(
          //   '#경기 남부 #여행',
          //   style: TextStyle(color: Colors.blue),
          // ),
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
