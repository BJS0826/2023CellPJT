import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  final moimID;
  const MembersPage({Key? key, required this.moimID}) : super(key: key);

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
  void initState() {
    super.initState();
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
                List<Future<DocumentSnapshot<Map<String, dynamic>>>> datasList =
                    [];
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
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshot.hasError) {
                              return Text('데이터를 불러올 수 없습니다.');
                            } else {
                              if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.exists) {
                                var moimJangData = snapshot.data;
                                String moimJangName = moimJangData!["userName"];

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
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage: NetworkImage(
                                                moimJangData["picked_image"]),
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
                        },
                      ),
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
                                        userMemberDatas[index]['picked_image'];
                                    String managementId =
                                        userMemberDatas[index].id;

                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                              radius: 20.0,
                                              backgroundImage:
                                                  NetworkImage(picked_image)),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      // 모달 창을 표시하기 전에 확인 다이얼로그를 표시
                                                      bool confirmTransfer =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('모임장 양도'),
                                                            content: Text(
                                                                '정말 양도하시겠습니까?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  // 확인 버튼을 누르면 true를 반환
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                                },
                                                                child:
                                                                    Text('확인'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  // 취소 버튼을 누르면 false를 반환
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false);
                                                                },
                                                                child:
                                                                    Text('취소'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                      // 확인 버튼을 눌렀을 때 양도 이벤트 실행
                                                      if (confirmTransfer ==
                                                          true) {
                                                        try {
                                                          DocumentReference
                                                              moimRef =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Moim')
                                                                  .doc(widget
                                                                      .moimID);

                                                          Map<String, dynamic>
                                                              updatedLeaderData =
                                                              {
                                                            managementId:
                                                                userName
                                                          };

                                                          Map<String, dynamic>
                                                              dataToUpdate = {
                                                            'moimLeader':
                                                                updatedLeaderData,
                                                          };

                                                          await moimRef.update(
                                                              dataToUpdate);

                                                          print(
                                                              'Moim 문서의 "moimLeader" 필드가 업데이트되었습니다.');
                                                          setState(() {});
                                                        } catch (e) {
                                                          print(
                                                              'Moim 문서 "moimLeader" 필드 업데이트 오류: $e');
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Color(0xFFFF6F61),
                                                    ),
                                                    child: Text(
                                                      '모임장 양도',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      // 모달 창을 표시하기 전에 확인 다이얼로그를 표시
                                                      bool confirmRelease =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('운영진 해제'),
                                                            content: Text(
                                                                '운영진에서 해제하시겠습니까?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  // 확인 버튼을 누르면 true를 반환
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                                },
                                                                child:
                                                                    Text('확인'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  // 취소 버튼을 누르면 false를 반환
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false);
                                                                },
                                                                child:
                                                                    Text('취소'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                      // 확인 버튼을 눌렀을 때 운영진 해제 이벤트 실행
                                                      if (confirmRelease ==
                                                          true) {
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
                                                            ),
                                                          );
                                                        } else {
                                                          try {
                                                            await firestore
                                                                .collection(
                                                                    "Moim")
                                                                .doc(widget
                                                                    .moimID)
                                                                .update({
                                                              'oonYoungJinList.$managementId':
                                                                  FieldValue
                                                                      .delete(),
                                                            }).then((value) {
                                                              setState(() {});
                                                              print(
                                                                  '문서의 userMembers 맵에서 id 삭제 완료');
                                                            }).catchError(
                                                                    (error) {
                                                              print(
                                                                  '삭제 중 오류 발생: $error');
                                                            });
                                                          } catch (e) {
                                                            print(
                                                                '운영진 해제 오류: $e');
                                                          }
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Color(0xFFFF6F61),
                                                    ),
                                                    child: Text(
                                                      '운영진 해제',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0),
                                                    ),
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
                                        userMemberDatas2[index]['picked_image'];
                                    String id = userMemberDatas2[index].id;

                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                              radius: 20.0,
                                              backgroundImage:
                                                  NetworkImage(picked_image)),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                  // '임명' 버튼
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      // 모달 창을 표시하기 전에 확인 다이얼로그를 표시
                                                      bool confirmAppointment =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text('임명'),
                                                            content: Text(
                                                                '사용자를 모임장으로 임명 하시겠습니까?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  // 확인 버튼을 누르면 true를 반환
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                                },
                                                                child:
                                                                    Text('확인'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  // 취소 버튼을 누르면 false를 반환
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false);
                                                                },
                                                                child:
                                                                    Text('취소'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                      // 확인 버튼을 눌렀을 때 임명 이벤트 실행
                                                      if (confirmAppointment ==
                                                          true) {
                                                        try {
                                                          await firestore
                                                              .collection(
                                                                  'Moim')
                                                              .doc(
                                                                  widget.moimID)
                                                              .update({
                                                            'oonYoungJinList.$id':
                                                                userName,
                                                          });
                                                          setState(() {});
                                                          print(
                                                              '사용자를 모임장으로 임명 했습니다.');
                                                        } catch (e) {
                                                          print(
                                                              '사용자 추가 중 오류가 발생했습니다: $e');
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Color(0xFFFF6F61),
                                                    ),
                                                    child: Text(
                                                      '임명',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),

// '강퇴' 버튼
                                                  if (management)
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // 모달 창을 표시하기 전에 확인 다이얼로그를 표시
                                                        bool confirmExpulsion =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text('강퇴'),
                                                              content: Text(
                                                                  '사용자를 강퇴 하시겠습니까?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // 확인 버튼을 누르면 true를 반환
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child: Text(
                                                                      '확인'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // 취소 버튼을 누르면 false를 반환
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false);
                                                                  },
                                                                  child: Text(
                                                                      '취소'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );

                                                        // 확인 버튼을 눌렀을 때 강퇴 이벤트 실행
                                                        if (confirmExpulsion ==
                                                            true) {
                                                          try {
                                                            bool
                                                                isManagementMember =
                                                                oonYoungJinList
                                                                    .keys
                                                                    .toString()
                                                                    .contains(
                                                                        id);
                                                            if (isManagementMember) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        '강퇴 실패'),
                                                                    content: Text(
                                                                        '운영진은 강퇴할 수 없습니다.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            '확인'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              // 운영진이 아닌 경우 강퇴 진행
                                                              await firestore
                                                                  .collection(
                                                                      'Moim')
                                                                  .doc(widget
                                                                      .moimID)
                                                                  .update({
                                                                'moimMembers.$id':
                                                                    FieldValue
                                                                        .delete(),
                                                              }).then((value) {
                                                                setState(() {});
                                                                print(
                                                                    '사용자를 강퇴 했습니다.');
                                                              }).catchError(
                                                                      (error) {
                                                                print(
                                                                    '삭제 중 오류 발생: $error');
                                                              });
                                                            }
                                                          } catch (e) {
                                                            print('강퇴 오류: $e');
                                                          }
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Color(0xFFFF6F61),
                                                      ),
                                                      child: Text(
                                                        '강퇴',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                ],
                                              )
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
      ),
    );
  }
}
