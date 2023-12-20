import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'moimjang.dart';

class GroupInfoPage extends StatefulWidget {
  final moimID;

  const GroupInfoPage({
    super.key,
    required this.moimID,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  String MoimJang = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  @override
  initState() {
    // TODO: implement initState
  }

  bool management = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection("Moim").doc(widget.moimID).get(),
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
              List<dynamic> oonYoungJin = moimData.get('oonYoungJin');
              var moimCategory = moimData['moimCategory'];
              var moimLeader = moimData['moimLeader'];
              Map<String, dynamic> Leader = moimData.get("moimLeader");
              Map<String, dynamic> oonYoungJinList =
                  moimData.get("oonYoungJinList");
              String name = Leader.keys.first;

              String _selectedItem = moimData.get('moimCategory');
              String _selectedLocation = moimData.get('moimLocation');

              print("=======================================");
              print("모임리더 : $moimLeader");
              print("모임리더1 : ${Leader.keys}");
              print("모임리더1 : ${Leader.values}");
              print("모임리더 : $oonYoungJinList");
              print("모임리더1 : ${oonYoungJinList.keys}");
              print("모임리더1 : ${oonYoungJinList.values}");
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

              for (int i = 0; i < oonYoungJinList.length; i++) {
                if (user?.uid == oonYoungJinList[i] || user?.uid == MoimJang) {
                  management = true;
                }
              }

              return management
                  ? Scaffold(
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
                              const Text('모임 수정'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    for (int i = 0;
                                        i < oonYoungJinList.length;
                                        i++) {
                                      if (user?.uid == oonYoungJin[i] ||
                                          user?.uid == MoimJang) {
                                        print("ㅋㅋㅋㅋ");
                                      }
                                    }
                                  },
                                  child: Text("수정하기")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("취소하기")),
                            ],
                          ),
                          // 1번째 열 - '모임명'
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "모임명",
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
                            title: TextFormField(
                              decoration: InputDecoration(
                                  labelText: moimTitle,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "모임장",
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

                                child: TextButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MoimJangModi(
                                                    moimID: widget.moimID,
                                                    Leader: Leader,
                                                    oonYoungJinList:
                                                        oonYoungJinList,
                                                  )));
                                      setState(() {});
                                    },
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Leader.keys.first,
                                          style: TextStyle(fontSize: 20),
                                        )))),
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
                            title: TextFormField(
                              decoration: InputDecoration(
                                  labelText: moimIntroduction,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
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
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                value: _selectedItem,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedItem = newValue!;
                                  });
                                },
                                items: <String>[
                                  '독서',
                                  '경제',
                                  '예술',
                                  '음악',
                                  "운동",
                                  "직무",
                                  "자유",
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
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
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                value: _selectedLocation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedLocation = newValue!;
                                  });
                                },
                                items: <String>[
                                  '서울',
                                  '경기 남부',
                                  '경기 북부',
                                  '인천',
                                  "부산",
                                  "그 외",
                                  "온라인"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
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
                                  bottom: 0.0), // 여백 조절 및 모서리 둥글게
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:
                                  Text('${moimMembers.length} / ${moimLimit}'),
                            ),
                          ),
                          // 11번째 열 - 투명한 회색 글씨로 '(현재 / 전체)'
                          ListTile(
                            title: Container(
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 0.0,
                                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
                              child: Text('(현재 / 전체)',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // 나머지 페이지 내용 추가
                          // ...
                        ],
                      ),
                    )
                  : Scaffold(
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
                                "모임명",
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
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(moimTitle),
                            ),
                          ),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "모임장",
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
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text('$MoimJang'),
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
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(moimIntroduction),
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
                              child: Text(moimCategory),
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
                              child: Text(moimLocation),
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
                                  bottom: 0.0), // 여백 조절 및 모서리 둥글게
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:
                                  Text('${moimMembers.length} / ${moimLimit}'),
                            ),
                          ),
                          // 11번째 열 - 투명한 회색 글씨로 '(현재 / 전체)'
                          ListTile(
                            title: Container(
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 0.0,
                                  bottom: 4.0), // 여백 조절 및 모서리 둥글게
                              child: Text('(현재 / 전체)',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // 나머지 페이지 내용 추가
                          // …
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
      },
    );
  }
}
