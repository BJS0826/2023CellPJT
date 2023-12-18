import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'moimjang.dart';

class GroupInfoPage extends StatefulWidget {
  final moimID;
  final moimTitle;
  final moimIntroduction;
  final moimLocation;
  final moimPoint;
  final boardId;
  final createdTime;
  final moimLimit;
  final List<dynamic> moimMembers;
  final moimJangID;
  final moimSchedule;
  final List<dynamic> oonYoungJin;

  final moimCategory;

  const GroupInfoPage({
    super.key,
    this.moimTitle,
    this.moimIntroduction,
    this.moimLocation,
    this.moimPoint,
    this.boardId,
    this.createdTime,
    this.moimLimit,
    required this.moimMembers,
    this.moimJangID,
    this.moimSchedule,
    required this.oonYoungJin,
    this.moimCategory,
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
  late String _selectedItem;
  late String _selectedLocation;

  @override
  initState() {
    // TODO: implement initState
    fetchUserName();
    user = _auth.currentUser;
    managementCheck();
    _selectedItem = widget.moimCategory;
    _selectedLocation = widget.moimLocation;
  }

  Future<String?> fetchUserName() async {
    try {
      DocumentSnapshot userSnapshot = await firestore
          .collection('user') // 사용자 정보가 있는 컬렉션 이름
          .doc(widget.moimJangID) // 문서 ID
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data();
        // 문서에서 'userName' 필드 가져오기
        setState(() {
          MoimJang = userSnapshot['userName'];
        });
        print("모임장 : $MoimJang");
      } else {
        print('해당 ID의 유저 문서를 찾을 수 없습니다.');
        return null;
      }
    } catch (e) {
      print('유저 이름 가져오기 중 오류 발생: $e');
      return null;
    }
    return null;
  }

  Future<List<String>> oonYoungJinLists(oonYoungJinList) async {
    for (int i = 0; i < widget.oonYoungJin.length; i++) {
      DocumentSnapshot Snapshot2 = await firestore
          .collection('user') // 사용자 정보가 있는 컬렉션 이름
          .doc(widget.oonYoungJin[i]) // 문서 ID
          .get();
      String str = Snapshot2["userName"];
      oonYoungJinList.add(str);
    }
    return oonYoungJinList;
  }

  bool management = false;

  void managementCheck() {
    for (int i = 0; i < widget.oonYoungJin.length; i++) {
      if (user?.uid == widget.oonYoungJin[i] || user?.uid == MoimJang) {
        setState(() {
          management = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          for (int i = 0; i < widget.oonYoungJin.length; i++) {
                            if (user?.uid == widget.oonYoungJin[i] ||
                                user?.uid == MoimJang) {
                              setState(() {});
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
                        labelText: widget.moimTitle,
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
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoimJangModi(
                                        moimID: widget.moimID,
                                        MoimJang: MoimJang,
                                      ))),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                MoimJang,
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
                        labelText: widget.moimIntroduction,
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
                          color: Colors.grey.withOpacity(0.2), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                        '${widget.moimMembers.length} / ${widget.moimLimit}'),
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
                    child:
                        Text('(현재 / 전체)', style: TextStyle(color: Colors.grey)),
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
                          color: Colors.grey.withOpacity(0.2), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(widget.moimTitle),
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
                          color: Colors.grey.withOpacity(0.2), width: 2.0),
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
                          color: Colors.grey.withOpacity(0.2), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(widget.moimIntroduction),
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
                    child: Text(widget.moimCategory),
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
                    child: Text(widget.moimLocation),
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
                          color: Colors.grey.withOpacity(0.2), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                        '${widget.moimMembers.length} / ${widget.moimLimit}'),
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
                    child:
                        Text('(현재 / 전체)', style: TextStyle(color: Colors.grey)),
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
