import 'package:cellpjt/appbar/creategroup.dart';
import 'package:cellpjt/appbar/groupsearch.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/bottomnav/editprofile.dart';
import 'package:cellpjt/func2/aboutgroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowProfile extends StatefulWidget {
  final userID;
  const ShowProfile({super.key, required this.userID});

  @override
  _ShowProfileState createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool exercise = false;
  bool economy = false;
  bool art = false;
  bool music = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              const Text('셀모임'),
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
        future: _firestore.collection("user").doc(widget.userID).get(),
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
                List interestsList = userData["interests"];

                for (String interests in interestsList) {
                  if (interests.contains('운동')) {
                    exercise = true;
                  }
                  if (interests.contains('경제')) {
                    economy = true;
                  }
                  if (interests.contains('예술')) {
                    art = true;
                  }
                  if (interests.contains('음악')) {
                    music = true;
                  }
                }

                print(
                    "테스트 !! 이메일 : $email / 모임리스트 : $myMoimList / 사진url : $pickedImage / 이름 : $userName");

                List<Future<DocumentSnapshot<Map<String, dynamic>>>> datasList =
                    [];

                for (String id in myMoimList.keys) {
                  Future<DocumentSnapshot<Map<String, dynamic>>> data =
                      _firestore.collection("Moim").doc(id).get();
                  datasList.add(data);
                }

                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
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
                                  'point : 0',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    buildInterests(interestsList),
                    const SizedBox(height: 16.0),
                    buildLocations(),
                    const SizedBox(height: 16.0),

                    // 프로필 정보

                    // 관심사 리스트

                    SizedBox(height: 16.0),
                    // 지역 리스트

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
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
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

  Widget buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfilePage()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFF6F61), // 버튼 색상을 코랄 블루로 변경
      ),
      child: Text(
        '프로필 편집',
        style: TextStyle(
          color: Colors.white, // 텍스트 색상을 흰색으로 변경
        ),
      ),
    );
  }

  Widget buildInterests(List interestsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '관심사',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildInterestList(interestsList),
      ],
    );
  }

  Widget buildInterestList(List interestsList) {
    return ListView(
      shrinkWrap: true,
      children: [
        buildInterestItem(
            '운동', 'assets/category_sports.png', exercise, interestsList),
        buildInterestItem(
            '경제', 'assets/category_economy.png', economy, interestsList),
        buildInterestItem('예술', 'assets/category_art.png', art, interestsList),
        buildInterestItem(
            '음악', 'assets/category_music.png', music, interestsList),
        // ... 추가 관심사 아이템
      ],
    );
  }

  Widget buildInterestItem(
      String interest, String imagePath, bool choice, List interestsList) {
    return FutureBuilder(
        future: _firestore.collection("user").doc(widget.userID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('');
          } else {
            var data = snapshot.data;
            List interestsLists = data?['interests'];
            bool choice = interestsLists.contains(interest);

            return ListTile(
              leading: ClipOval(
                child: Container(
                  width: 25.0, // 조절된 원의 크기
                  height: 25.0, // 조절된 원의 크기
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    color: choice ? null : Colors.grey,
                  ),
                ),
              ),
              title: Text(interest),
            );
          }
        });
  }

  Widget buildLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지역',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildLocationList(),
      ],
    );
  }

  Widget buildLocationList() {
    return FutureBuilder(
        future: _firestore.collection("user").doc(widget.userID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            var data = snapshot.data!;
            List Location = data['myLocation'];
            return ListView.builder(
              //if else // location field 추가 => 회원가입시, 필드 추가
              shrinkWrap: true,
              itemCount: Location.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(Location[index]), // 지역명 또는 선택된 지역
                );
              },
            );
          }
        });
  }

  Widget buildMyGroupsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  title: Text('모임명'),
                  subtitle: Text('1/20'), // 인원 수 표시
                ),
                // ... 추가 정보 (모임 인원 등)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMyMeetings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 정모',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildMyMeetingsCarousel(),
      ],
    );
  }

  Widget buildMyMeetingsCarousel() {
    return Container(
        height: 100.0, // 높이는 100.0으로 유지
        child: PageView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 2.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9, // 이미지의 가로 세로 비율
                        child: Image.asset(
                          'assets/meeting_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '정모명과 날짜',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
