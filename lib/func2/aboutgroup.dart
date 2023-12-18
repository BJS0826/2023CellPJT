import 'package:cellpjt/func1/login.dart';
import 'package:cellpjt/func2/board.dart';
import 'package:cellpjt/func2/groupinfo.dart';
import 'package:cellpjt/func2/meetingschedule.dart';
import 'package:cellpjt/func2/meetingsettings.dart';
import 'package:cellpjt/func2/pointshop.dart';
import 'package:cellpjt/func2/postfeed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/func2/members.dart';

class AboutGroupPage extends StatefulWidget {
  @override
  _AboutGroupPageState createState() => _AboutGroupPageState();
}

class _AboutGroupPageState extends State<AboutGroupPage> {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool management = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;
  String? moimID;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = _auth.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('user').doc(user?.uid).get();
      print("userUID!!!!! : ${user?.uid}");
      setState(() {
        userData = Future.value(snapshot);
        print("USER DATA !!!! :  $userData");

        final check = snapshot["myMoimList"];
        moimID = snapshot.data()?['myMoimList'][0];
        //moimID = snapshot["myMoimList"][0];
        print("MoimID !!!!! :  $check");
        print("MoimID !!!!! :  $moimID");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('Moim').doc(moimID).get(),
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
                var moimIntroduction = moimData['moimIntroduction'];
                var moimLocation = moimData['moimLocation'];
                var moimPoint = moimData['moimPoint'];
                var boardId = moimData['boardID'];
                var createdTime = moimData['createdTime'];
                var moimJangID = moimData['moimJang'];
                var moimImage = moimData['moimImage'];

                var moimLimit = moimData['moimLimit'];
                List<dynamic> moimMembers = moimData['moimMembers'];
                var moimSchedule = moimData['moimSchedule'];
                List<dynamic> oonYoungJin = moimData['oonYoungJin'];
                var moimCategory = moimData['moimCategory'];

                print("=======================================");

                print("모임이름 : $moimTitle");
                print("모임사진 : $moimImage");
                print("모임소개 : $moimIntroduction");
                print("모임장소 : $moimLocation");
                print("모임포인트 : $moimPoint");
                print("모임게시판ID : $boardId");
                print("모임만든날짜 : $createdTime");
                print("모임장 ID : $moimJangID");
                print("모임인원 : $moimLimit");
                print("모임맴버들 : $moimMembers");
                print("정모스케쥴 : $moimSchedule");
                print("모임카테고리 : $moimCategory");
                print("운영진 ID 리스트 : $oonYoungJin");

                print("=======================================");

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
                              Container(
                                width: 80,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MembersPage(),
                                      ), // 모임원 페이지로 이동
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8), // 내부 간격 조절
                                  ),
                                  child: Text(
                                    '모임원 >',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12, // 폰트 크기 조절
                                    ),
                                  ),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GroupInfoPage(
                                              moimID: moimID,
                                              moimCategory: moimCategory,
                                              moimTitle: moimTitle,
                                              boardId: boardId,
                                              createdTime: createdTime,
                                              moimIntroduction:
                                                  moimIntroduction,
                                              moimJangID: moimJangID,
                                              moimLimit: moimLimit,
                                              moimLocation: moimLocation,
                                              moimMembers: moimMembers,
                                              moimPoint: moimPoint,
                                              moimSchedule: moimSchedule,
                                              oonYoungJin: oonYoungJin,
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
                                                MeetingSchedulePage(),
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
                                            builder: (context) => BoardPage(),
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
                                      onPressed: () {
                                        // 단체채팅 페이지 연결
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
                                  builder: (context) => PostFeedPage(),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                    ],
                  ),
                );
              } else {
                return Scaffold(
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
