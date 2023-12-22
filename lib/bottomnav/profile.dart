import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/bottomnav/editprofile.dart';
import 'package:cellpjt/func2/aboutgroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '셀모임',
      home: Scaffold(
        appBar: AppBar(
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // 검색 버튼 페이지 연결
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // 글 작성 버튼 페이지 연결
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateGroupPage()),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // 글 작성 버튼 페이지 연결
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
            ),
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
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection("user").doc(user!.uid).get(),
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
                  var userData = snapshot.data!;

                  String email = userData["email"];
                  Map<String, dynamic> myMoimList = userData["myMoimList"];
                  String pickedImage = userData["picked_image"];
                  String userName = userData["userName"];

                  print(
                      "테스트 이메일 : $email / 모임리스트 : $myMoimList / 사진url : $pickedImage / 이름 : $userName");

                  List<Future<DocumentSnapshot<Map<String, dynamic>>>>
                      datasList = [];

                  for (String id in myMoimList.keys) {
                    Future<DocumentSnapshot<Map<String, dynamic>>> data =
                        _firestore.collection("Moim").doc(id).get();
                    datasList.add(data);
                  }

                  return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      // 프로필 정보
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 프로필 이미지, 이름, 소개 및 편집 버튼
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(pickedImage),
                              ),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '한국의 일론 머스크',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()),
                              );
                            },
                            child: Text('프로필 편집'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      // 관심사 리스트
                      Text(
                        '관심사',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      // GridView로 관심사 표시
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        children: [
                          ElevatedButton(onPressed: () {}, child: Text('운동')),
                          ElevatedButton(onPressed: () {}, child: Text('경제')),
                          ElevatedButton(onPressed: () {}, child: Text('예술')),
                          ElevatedButton(onPressed: () {}, child: Text('음악')),
                          // ... 추가 관심사 버튼
                        ],
                      ),
                      SizedBox(height: 16.0),
                      // 지역 리스트
                      Text(
                        '지역',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      // ListView로 지역 표시
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('서울'), // 지역명 또는 선택된 지역
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                      // 내 모임 리스트
                      Text(
                        '내 모임',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      // ListView로 내 모임 표시

                      FutureBuilder(
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
                                  var MoImDatas = snapshot.data;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: MoImDatas!.length,
                                    itemBuilder: (context, index) {
                                      String moimTitle =
                                          MoImDatas[index]["moimTitle"];
                                      String moimImage =
                                          MoImDatas[index]["moimImage"];
                                      String moimTitles =
                                          MoImDatas[index]["moimTitle"];
                                      String moimID = MoImDatas[index].id;

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AboutGroupPage(
                                                        moimID: moimID),
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Card(
                                            elevation: 2.0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage:
                                                        NetworkImage(moimImage),
                                                  ),
                                                  title: Text(moimTitle),
                                                  subtitle: Text(moimTitles,
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ),
                                                // ... 추가 정보 (모임 인원 등)
                                              ],
                                            ),
                                          ),
                                        ),
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
                      SizedBox(height: 16.0),
                      // 내 정모 리스트 (슬라이드로 볼 수 있게끔)
                      Text(
                        '내 정모',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      // Container 내에서 PageView로 정모 목록 표시
                      Container(
                        height: 200.0,
                        child: PageView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 2.0,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Image.asset(
                                      'assets/meeting_image.jpg',
                                      fit: BoxFit.cover,
                                      height: 120.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '정모명과 날짜',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
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
      ),
    );
  }
}




/////  <!== 모임 순서 시간순서대로 하는 로직 (추후 적용하기) ==> 
///
// ///// Firestore 쿼리 예시
// FirebaseFirestore.instance
//     .collection('moims')
//     .doc('yourDocId')
//     .collection('myMoimList')
//     .get()
//     .then((QuerySnapshot querySnapshot) {
//   // Firestore로부터 데이터를 가져온 후
//   List<Map<String, dynamic>> sortedList = [];

//   querySnapshot.docs.forEach((doc) {
//     sortedList.add({
//       'docId': doc.id,
//       'time': (doc.data() as Map<String, dynamic>)['time'] // 'time' 값을 가져와 sortedList에 추가
//     });
//   });

//   // 'time' 필드를 기준으로 정렬
//   sortedList.sort((a, b) => a['time'].compareTo(b['time']));

//   // 정렬된 리스트를 출력하거나 사용할 수 있습니다.
//   sortedList.forEach((element) {
//     print('${element['docId']}: ${element['time']}');
//     // 필요한 처리 수행
//   });
// })
// .catchError((error) {
//   // 오류 처리
//   print("Error getting documents: $error");
// });
