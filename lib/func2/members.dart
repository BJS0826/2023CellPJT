import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  final moimID;
  const MembersPage({super.key, required this.moimID});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> fetchData() async {
    return firestore.collection("Moim").doc(widget.moimID).get();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool management = false;
  User? user;

  @override
  initState() {
    super.initState();
    // TODO: implement initState
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
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
                const Text('모임원'),
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
        body: FutureBuilder<DocumentSnapshot>(
          future: fetchData(),
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
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  var moimData = snapshot.data!;
                  Map<String, dynamic> oonYoungJinList =
                      moimData.get("oonYoungJinList");

                  for (String id in oonYoungJinList.keys) {
                    if (user?.uid == id) {
                      management = true;
                    }
                  }

                  Map<String, dynamic> moimJang = moimData['moimLeader'];
                  String moimJangName = moimJang.values.first;

                  print("모임장 :  $moimJangName");
                  //////
                  ///
                  ///
                  List<Future<DocumentSnapshot<Map<String, dynamic>>>>
                      datasList = [];
                  Map<String, dynamic> moimData1 = moimData["oonYoungJinList"];

                  for (String id in moimData1.keys) {
                    Future<DocumentSnapshot<Map<String, dynamic>>> data =
                        firestore.collection("user").doc(id).get();
                    datasList.add(data);
                    print('맴버ID : $id');
                    print('맴버데이터 : $data');
                    print('맴버데이터리스트 : $datasList');
                  }

                  List<Future<DocumentSnapshot<Map<String, dynamic>>>>
                      moimMembers = [];
                  Map<String, dynamic> moimMembers1 = moimData["moimMembers"];

                  for (String id in moimMembers1.keys) {
                    Future<DocumentSnapshot<Map<String, dynamic>>> data =
                        firestore.collection("user").doc(id).get();
                    moimMembers.add(data);
                    print('맴버ID : $id');
                    print('맴버데이터 : $data');
                    print('맴버데이터리스트 : $moimMembers');
                  }

                  Future.wait(datasList).then(
                      (List<DocumentSnapshot<Map<String, dynamic>>> snapshots) {
                    print("스냅샷 $snapshots");
                  }).catchError((error) {
                    // 에러 처리
                    print('에러 발생: $error');
                  });
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 130,
                        child: FutureBuilder<DocumentSnapshot>(
                            future: firestore
                                .collection("user")
                                .doc(moimJang.keys.first)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Text('데이터를 불러올 수 없습니다.');
                                } else {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.exists) {
                                    var moimJangData = snapshot.data;
                                    String moimJangName =
                                        moimJangData!["userName"];

                                    return ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  '모임장',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 모임장 정보 표시
                                            ListTile(
                                              leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundImage: NetworkImage(
                                                    moimJangData[
                                                        "picked_image"]),
                                              ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    moimJangName,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  Text('모임장'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  return Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                }
                              }
                            }),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '운영진',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 170,
                        child: FutureBuilder<List<DocumentSnapshot>>(
                          future: Future.wait(datasList),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              if (snapshot.hasError) {
                                return Text('데이터를 불러올 수 없습니다.');
                              } else {
                                if (snapshot.hasData && snapshot.data != null) {
                                  var userMemberDatas = snapshot.data;

                                  return ListView.builder(
                                    itemCount: userMemberDatas!.length,
                                    itemBuilder: (context, index) {
                                      String userName =
                                          userMemberDatas[index]['userName'];
                                      String picked_image =
                                          userMemberDatas[index]
                                              ['picked_image'];
                                      String managementId =
                                          userMemberDatas[index].id;

                                      return Column(
                                        children: [
                                          // 모임장 정보 표시
                                          ListTile(
                                            leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundImage:
                                                    NetworkImage(picked_image)),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      userName,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    Text("운영진"),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      if (moimJang.keys
                                                          .toString()
                                                          .contains(
                                                              managementId)) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "모임장은 운영진에서 해제 할 수 없습니다"),
                                                          backgroundColor:
                                                              Colors.blue,
                                                        ));
                                                      } else {
                                                        await firestore
                                                            .collection("Moim")
                                                            .doc(widget.moimID)
                                                            .update({
                                                          'oonYoungJinList.$managementId':
                                                              FieldValue
                                                                  .delete(),
                                                        }).then((value) {
                                                          // 삭제 성공 시 동작
                                                          setState(() {});
                                                          print(
                                                              '문서의 userMembers 맵에서 id 삭제 완료');
                                                        }).catchError((error) {
                                                          // 오류 발생 시 동작
                                                          print(
                                                              '삭제 중 오류 발생: $error');
                                                        });
                                                      }
                                                    },
                                                    child: Text('운영진해제'))
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                return Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              }
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '모임원',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      //     // 나머지 모임원 목록 표시
                      Expanded(
                        child: FutureBuilder<List<DocumentSnapshot>>(
                          future: Future.wait(moimMembers),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              if (snapshot.hasError) {
                                return Text('데이터를 불러올 수 없습니다.');
                              } else {
                                if (snapshot.hasData && snapshot.data != null) {
                                  var userMemberDatas2 = snapshot.data;

                                  return ListView.builder(
                                    itemCount: userMemberDatas2!.length,
                                    itemBuilder: (context, index) {
                                      String userName =
                                          userMemberDatas2[index]['userName'];
                                      String picked_image =
                                          userMemberDatas2[index]
                                              ['picked_image'];
                                      String id = userMemberDatas2[index].id;

                                      return Column(
                                        children: [
                                          // 모임장 정보 표시
                                          ListTile(
                                            leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundImage:
                                                    NetworkImage(picked_image)),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      userName,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    Text("모임원"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            // userMembers 컬렉션에 새로운 문서 추가
                                                            await firestore
                                                                .collection(
                                                                    'Moim')
                                                                .doc(widget
                                                                    .moimID)
                                                                .update({
                                                              'oonYoungJinList.$id':
                                                                  userName,
                                                              // 여기에 다른 필드도 추가할 수 있습니다.
                                                            });
                                                            setState(() {});

                                                            print(
                                                                '사용자를 userMembers 컬렉션에 추가했습니다.');
                                                          } catch (e) {
                                                            print(
                                                                '사용자 추가 중 오류가 발생했습니다: $e');
                                                          }
                                                        },
                                                        child: Text("운영진임명")),
                                                    if (management)
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          CollectionReference
                                                              userMemberCollection =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Moim');

                                                          // 해당 문서의 userMembers 맵에서 id 삭제
                                                          userMemberCollection
                                                              .doc(
                                                                  widget.moimID)
                                                              .update({
                                                            'moimMembers.$id':
                                                                FieldValue
                                                                    .delete(),
                                                          }).then((value) {
                                                            // 삭제 성공 시 동작
                                                            setState(() {});
                                                            print(
                                                                '문서의 userMembers 맵에서 id 삭제 완료');
                                                          }).catchError(
                                                                  (error) {
                                                            // 오류 발생 시 동작
                                                            print(
                                                                '삭제 중 오류 발생: $error');
                                                          });
                                                        },
                                                        child: Text("강퇴"),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                return Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
              }
            }
          },
        ));
  }
}
