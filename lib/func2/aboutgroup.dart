import 'dart:math';

import 'package:cellpjt/func2/board.dart';
import 'package:cellpjt/func2/chat_screen.dart';
import 'package:cellpjt/func2/groupinfo.dart';
import 'package:cellpjt/func2/joinmeeting.dart';
import 'package:cellpjt/func2/meetingschedule.dart';
import 'package:cellpjt/func2/meetingsettings.dart';
import 'package:cellpjt/func2/pointshop.dart';
import 'package:cellpjt/func2/postfeed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/func2/members.dart';

class AboutGroupPage extends StatefulWidget {
  final moimID;

  const AboutGroupPage({super.key, this.moimID});
  @override
  _AboutGroupPageState createState() => _AboutGroupPageState();
}

class _AboutGroupPageState extends State<AboutGroupPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late bool management = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;
  Map<String, dynamic>? moimID1;
  String? moimID;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = _auth.currentUser;
    fetchUserData();
    moimID = widget.moimID;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getEventData() async {
    return firestore
        .collection("feed")
        .where("moimId", isEqualTo: moimID)
        .orderBy("createdTime", descending: true)
        .snapshots();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('user').doc(user?.uid).get();
      print("userUID!!!!! : ${user?.uid}");
      setState(() {
        userData = Future.value(snapshot);
        print("USER DATA !!!! :  $userData");

        final check = snapshot["myMoimList"];
        moimID1 = snapshot.data()!['myMoimList'];
        if (moimID == null || moimID!.length < 3) {
          moimID = "s5p3v7jmie";
        }

        //moimID = snapshot["myMoimList"][0];
        print("MoimID !!!!! :  $check");
        print("MoimID !!!!! :  $moimID");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('Moim').doc(moimID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('데이터를 불러올 수 없습니다.'),
                ),
              );
            } else {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.exists) {
                var moimData = snapshot.data!;

                var moimTitle = moimData['moimTitle'];

                var moimImage = moimData['moimImage'];

                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.only(top: 20), // 버튼 상단 간격 조절
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(top: 18.0, right: 20.0),
                      child: Row(
                        children: [
                          SizedBox(width: 8.0),
                          const Text('모임 소개'),
                        ],
                      ),
                    ),
                    titleSpacing: 0, // 간격을 조절합니다
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      void _showDialog(BuildContext context) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Container(
                                                height: 400.0,
                                                width: 300.0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 330,
                                                      width: 300,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image: NetworkImage(
                                                                  moimImage))),
                                                    ),
                                                    SizedBox(height: 20.0),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('닫기'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      return _showDialog(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: NetworkImage(moimImage),
                                    ),
                                  ),
                                  SizedBox(width: 13.0),
                                  Text(
                                    moimTitle,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                JoinMeetingPage(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(8),
                                      ),
                                      child: Text(
                                        '모임 가입',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10), // 간격 추가
                                  Container(
                                    width: 80,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MembersPage(moimID: moimID),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(8),
                                      ),
                                      child: Text(
                                        '모임원 >',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GroupInfoPage(
                                              moimID: moimID,
                                            ),
                                          ), // 모임 정보 페이지로 이동
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white, // 배경 색상 변경
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9.0),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MeetingSchedulePage(
                                              moimID: moimID,
                                            ),
                                          ), // 정모 일정 페이지로 이동
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9.0),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BoardPage(moimID: moimID),
                                          ), // 정모 일정 페이지로 이동
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9.0),
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
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              moimID: moimID,
                                              moimTitle: moimTitle,
                                            ),
                                          )),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9.0),
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
                          InkWell(
                            onTap: () {
                              // 클릭 이벤트를 처리하고 원하는 페이지로 이동합니다.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostFeedPage(moimID: moimID),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // 이미지
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icon_postfeed.png', // 로컬 이미지 경로
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16), // 간격 조절

                                    // 텍스트
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '피드 작성',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '신규 피드를 작성합니다.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                /*
                                Divider(
                                  // 회색 줄 추가
                                  color: Colors.grey.withOpacity(0.3), // 회색 설정
                                  height: 20, // 줄 사이 간격 조절
                                  thickness: 1, // 줄 두께 설정
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // 클릭 이벤트를 처리하고 원하는 페이지로 이동합니다.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PointShopPage(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // 이미지
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icon_pointshop.png', // 로컬 이미지 경로
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16), // 간격 조절

                                    // 텍스트
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '포인트 상점',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '포인트로 아이템을 구입합니다.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  // 회색 줄 추가
                                  color: Colors.grey.withOpacity(0.3), // 회색 설정
                                  height: 20, // 줄 사이 간격 조절
                                  thickness: 1, // 줄 두께 설정
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // 클릭 이벤트를 처리하고 원하는 페이지로 이동합니다.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MeetingSettingsPage(
                                      meetingName: 'Meeting Name'),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // 이미지
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icon_setting.png', // 로컬 이미지 경로
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16), // 간격 조절

                                    // 텍스트
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '설정',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '모임에 대한 설정을 합니다.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          */
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          StreamBuilder<QuerySnapshot>(
                            stream: firestore
                                .collection("feed")
                                .where("moimId", isEqualTo: moimID)
                                .snapshots(),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child:
                                        CircularProgressIndicator()); // 데이터를 기다리는 동안 로딩 표시
                              } else if (snapshot2.hasError) {
                                return Center(
                                    child: Text('데이터를 가져오는 데 문제가 발생했습니다.'));
                              } else if (!snapshot2.hasData ||
                                  snapshot2.data == null) {
                                return Center(child: Text('데이터가 없습니다.'));
                              }

                              final documents = snapshot2.data!.docs;
                              List<Map<String, dynamic>> sortedData = [];
                              documents.forEach((doc) {
                                Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;
                                data['id'] = doc.id;
                                sortedData.add(data);
                              });

                              // 시간에 따라 정렬
                              sortedData.sort((a, b) => a['time']
                                  .compareTo(b['time'])); // 'time' 필드에 따라 정렬
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: sortedData.length,
                                itemBuilder: (context, index) {
                                  String feedImage =
                                      sortedData[index]["feedImage"];
                                  var preTime = sortedData[index]["time"];
                                  String time = preTime.toString();
                                  String feedContent =
                                      sortedData[index]["feedContent"];
                                  Map<String, dynamic> writer =
                                      sortedData[index]["writer"];
                                  String selectedMeeting =
                                      sortedData[index]["selectedMeeting"];
                                  String feedId = sortedData[index]['id'];

                                  return Card(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                        Flexible(
                                          flex: 3,
                                          child: Image.network(
                                            feedImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // 텍스트를 표시하는 부분
                                        Flexible(
                                            flex: 2,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  feedContent,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )))
                                      ]));

                                  return InkWell(
                                    onTap: () async {
                                      // 피드를 클릭했을 때 상세 내용 페이지로 이동
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FeedDetailPage(feedId: feedId),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: Card(
                                      elevation: 2.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        NetworkImage(feedImage),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '내용: $feedContent',
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ),
                                          Text('작성자 : ${writer.values.first}'),
                                          Text('모임종류 : $selectedMeeting'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Text('이 모임은 현재 접근이 제한되었습니다'),
                  ),
                );
              }
            }
          }
        });
  }
}

class FeedDetailPage extends StatelessWidget {
  final feedId;
  const FeedDetailPage({
    Key? key,
    required this.feedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('피드 상세 내용'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('feed').doc(feedId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Text('문서가 없습니다.');
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String feedDetailImage = data["feedImage"];
            String feedContent = data["feedContent"];
            String selectedMeeting = data["selectedMeeting"];
            int viewNumber = data["viewNumber"];
            int favorite = data["favorite"];
            Map<String, dynamic> writer = data["writer"];
            Timestamp time = data["time"];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(feedDetailImage),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '피드 모임 : $selectedMeeting',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '피드 내용 : $feedContent',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text('본 사람 수 : $viewNumber'),
                  Text('좋아요 한 사람수 :  $favorite'),
                  Text('글쓴이 : $writer'),
                  Text('시간(TimeStamp) : $time'),
                ],
              ),
            );
          }),
    );
  }
}
