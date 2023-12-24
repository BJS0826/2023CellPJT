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

  TextEditingController moimTitleController = TextEditingController();
  TextEditingController moimIntroductionController = TextEditingController();
  String selectedCatrgory = "";
  String selectedLocation = "";

  @override
  initState() {
    super.initState();
    // TODO: implement initState
    user = _auth.currentUser;
  }

  bool management = false;
  Future<DocumentSnapshot> fetchData() async {
    return firestore.collection("Moim").doc(widget.moimID).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fetchData(),
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

              var moimLimit = moimData['moimLimit'];

              var moimCategory = moimData['moimCategory'];
              Map<String, dynamic> moimMembers = moimData["moimMembers"];
              var moimMember = moimMembers.values;
              Map<String, dynamic> Leader = moimData.get("moimLeader");

              Map<String, dynamic> oonYoungJinList =
                  moimData.get("oonYoungJinList");

              //////

              for (String id in oonYoungJinList.keys) {
                if (user?.uid == id || user?.uid == Leader.values.first) {
                  management = true;
                }
              }

              //////
              Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
                  moimUpdate() async {
                DocumentSnapshot updatePrepare =
                    await firestore.collection("Moim").doc(widget.moimID).get();
                try {
                  if (updatePrepare.exists) {
                    // 현재 문서의 데이터 가져오기
                    Map<String, dynamic> currentData =
                        updatePrepare.data() as Map<String, dynamic>;

                    // 업데이트할 필드 및 값을 기존 데이터에 추가 또는 수정
                    if (moimTitleController.text.isNotEmpty) {
                      currentData['moimTitle'] = moimTitleController.text;
                    }
                    if (moimIntroductionController.text.isNotEmpty) {
                      currentData['moimIntroduction'] =
                          moimIntroductionController.text;
                    }

                    if (selectedCatrgory.length > 1) {
                      currentData['moimCategory'] = selectedCatrgory;
                    }
                    if (selectedLocation.length > 1) {
                      currentData['moimLocation'] = selectedLocation;
                    }

                    // 문서 업데이트
                    await firestore
                        .collection('Moim')
                        .doc(widget.moimID)
                        .update(currentData);
                    setState(() {
                      selectedCatrgory = "";
                      selectedLocation = "";
                    });

                    return ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text("수정완료"),
                      backgroundColor: Colors.blue,
                    ));
                  } else {
                    return ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text("수정실패"),
                      backgroundColor: Colors.blue,
                    ));
                  }
                } catch (e) {
                  return ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("수정실패"),
                    backgroundColor: Colors.blue,
                  ));
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
                              controller: moimTitleController,
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
                          // ListTile(
                          //   title: Container(
                          //       padding: EdgeInsets.all(8.0),
                          //       margin: EdgeInsets.only(
                          //           left: 8.0,
                          //           right: 8.0,
                          //           top: 4.0,
                          //           bottom: 4.0), // 여백 조절 및 모서리 둥글게

                          //       child: TextButton(
                          //           onPressed: () async {
                          //             await Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         MoimJangModi(
                          //                           moimID: widget.moimID,
                          //                           Leader: Leader,
                          //                           oonYoungJinList:
                          //                               oonYoungJinList,
                          //                         )));
                          //             setState(() {});
                          //           },
                          //           child: Align(
                          //               alignment: Alignment.centerLeft,
                          //               child: Text(
                          //                 Leader.values.first,
                          //                 style: TextStyle(fontSize: 20),
                          //               )))),
                          // ),
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
                              child: Text('${Leader.values.first}'),
                            ),
                          ),

                          // 3번째 열 - '모임소개'
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '모임 소개',
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
                              controller: moimIntroductionController,
                              maxLines: 5,
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
                              child: Row(
                                children: [
                                  DropdownButton<String>(
                                    value: moimCategory.toString(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCatrgory = newValue!;
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
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  if (selectedCatrgory.length > 1)
                                    Text("  == 선택 ==>    "),
                                  Text(selectedCatrgory),
                                ],
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
                              child: Row(
                                children: [
                                  DropdownButton<String>(
                                    value: moimLocation.toString(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedLocation = newValue!;
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
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  if (selectedLocation.length > 1)
                                    Text("  == 선택 ==>     "),
                                  Text(selectedLocation),
                                ],
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  bool isUserInList = false;
                                  print(oonYoungJinList.values);

                                  for (String id in oonYoungJinList.keys) {
                                    if (user?.uid == id) {
                                      isUserInList = true;
                                      break;
                                    }
                                  }

                                  if (isUserInList) {
                                    moimUpdate();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("수정하기 실패"),
                                      backgroundColor: Colors.blue,
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      0xFFFF6F61), // 헥사 코드 #FF6F61 (코랄 핑크)
                                  minimumSize: Size(300.0, 48.0), // 가로 길이 조절
                                ),
                                child: Text(
                                  "수정하기",
                                  style: TextStyle(
                                    fontSize: 16.0, // 폰트 크기 조절
                                    color: Colors.white, // 텍스트 색상 변경
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              child: Text('${Leader.values.first}'),
                            ),
                          ),
                          // 3번째 열 - '모임소개'
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '모임 소개',
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
