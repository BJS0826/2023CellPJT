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

                  for (String id in moimData["moimMembers"]) {
                    Future<DocumentSnapshot<Map<String, dynamic>>> data =
                        firestore.collection("user").doc(id).get();
                    datasList.add(data);
                    print('맴버ID : $id');
                    print('맴버데이터 : $data');
                    print('맴버데이터리스트 : $datasList');
                  }

                  Future.wait(datasList).then(
                      (List<DocumentSnapshot<Map<String, dynamic>>> snapshots) {
                    print("스냅샷 $snapshots");
                  }).catchError((error) {
                    // 에러 처리
                    print('에러 발생: $error');
                  });
                  return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
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
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: FutureBuilder<List<DocumentSnapshot>>(
                            future: Future.wait(datasList),
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
                                      snapshot.data != null) {
                                    var userMemberDatas = snapshot.data;

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
                                                  '운영진',
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
                                                backgroundColor: Colors.amber,
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
                      Container(
                        height: 600,
                        width: double.infinity,
                        color: Colors.amber,
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
        )

        //     ListTile(
        //       title: Padding(
        //         padding: const EdgeInsets.only(left: 8.0),
        //         child: Text(
        //           '모임원',
        //           style: TextStyle(
        //             fontSize: 20.0,
        //             fontWeight: FontWeight.bold,
        //             color: Colors.black,
        //           ),
        //         ),
        //       ),
        //     ),
        //     // 나머지 모임원 목록 표시
        //     ListTile(
        //       leading: CircleAvatar(
        //         radius: 20.0,
        //         backgroundImage: AssetImage('assets/profile_image.jpg'),
        //       ),
        //       title: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text('배예은'),
        //           Text('모임원'),
        //         ],
        //       ),
        //     ),
        //     // 필요에 따라 모임원을 추가하십시오.
        //     // ...

        //     SizedBox(height: 16.0),
        //     // 나머지 페이지 내용 추가
        //     // ...
        //   ],
        // ),
        );
  }
}
