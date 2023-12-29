import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedInterest = '';
  String selectedRegion = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  TextEditingController _nameContoroller = TextEditingController();
  TextEditingController _introductionController = TextEditingController();
  TextEditingController _churchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
          padding: EdgeInsets.only(top: 20),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 18.0, right: 20.0),
          child: Row(
            children: [
              SizedBox(width: 8.0),
              const Text('프로필 편집'),
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
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("user").doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
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
                print('userDATA!!! : $userData');
                String userName = userData['userName'];
                String myIntroduction = userData['myIntroduction'];
                String myChurch = userData['myChurch'];
                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "이름",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: TextFormField(
                            controller: _nameContoroller,
                            decoration: InputDecoration(
                              labelText: userName,
                              hintText: "이름을 입력하세요",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "소개글",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: TextFormField(
                            controller: _introductionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: myIntroduction,
                              hintText: "소개글을 입력하세요",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildInterestSection(),
                    _buildRegionSection(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "출석 교회 명",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: TextFormField(
                            controller: _churchController,
                            decoration: InputDecoration(
                              labelText: myChurch,
                              hintText: "출석 교회 명을 입력하세요",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_nameContoroller.text.isNotEmpty) {
                          userName = _nameContoroller.text;
                        }
                        if (_introductionController.text.isNotEmpty) {
                          myIntroduction = _introductionController.text;
                        }
                        if (_churchController.text.isNotEmpty) {
                          myChurch = _churchController.text;
                        }
                        Map<String, dynamic> updateUserData = {
                          'userName': userName,
                          'myChurch': myChurch,
                          'myIntroduction': myIntroduction
                        };
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(user!.uid)
                            .update(updateUserData);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6F61), // 코랄 핑크 색상
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: Size(double.infinity, 40), // 가로로 꽉 차게 설정
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '편집 완료',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildInterestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        SizedBox(height: 8.0),
        _buildInterestButtons(),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildInterestButtons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildInterestButton('독서', 'assets/category_reading.png'),
          _buildInterestButton('경제', 'assets/category_economy.png'),
          _buildInterestButton('예술', 'assets/category_art.png'),
          _buildInterestButton('음악', 'assets/category_music.png'),
          _buildInterestButton('운동', 'assets/category_sports.png'),
          _buildInterestButton('직무', 'assets/category_career.png'),
          _buildInterestButton('기타', 'assets/category_free.png')
        ],
      ),
    );
  }

  Widget _buildInterestButton(String interest, String iconPath) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("user").doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: 110, // 원하는 가로 크기 지정
              height: 40, // 원하는 세로 크기 지정
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    selectedInterest = interest;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedInterest == interest
                      ? Color(0xFFFF6F61)
                      : Colors.grey[200],
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      iconPath,
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8.0),
                    Text(interest),
                  ],
                ),
              ),
            );
          } else {
            var data = snapshot.data!;
            List interestsList = data['interests'];
            bool choice = interestsList.contains(interest);

            return Container(
              width: 110, // 원하는 가로 크기 지정
              height: 40, // 원하는 세로 크기 지정
              child: ElevatedButton(
                onPressed: () async {
                  if (choice) {
                    interestsList.remove(interest);
                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(user!.uid)
                        .update({'interests': interestsList});
                    setState(() {});
                  } else if (interestsList.length >= 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('관심사는 3개까지 선택 가능합니다')));
                  } else {
                    interestsList.add(interest);
                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(user!.uid)
                        .update({'interests': interestsList});
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: choice ? Color(0xFFFF6F61) : Colors.grey[200],
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      iconPath,
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8.0),
                    Text(interest),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildRegionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        _buildRegionButtons(),
      ],
    );
  }

  Widget _buildRegionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildRegionButton('서울'),
          _buildRegionButton('경기 남부'),
          _buildRegionButton('경기 북부'),
          _buildRegionButton('인천'),
          _buildRegionButton('부산'),
          _buildRegionButton('그 외'),
          _buildRegionButton('온라인'),
        ],
      ),
    );
  }

  Widget _buildRegionButton(String region) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("user").doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedRegion = region;
                });
              },
              style: ElevatedButton.styleFrom(
                primary: selectedRegion == region
                    ? Color(0xFFFF6F61)
                    : Colors.grey[200],
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(80, 40),
              ),
              child: Text(region),
            );
          } else {
            var data = snapshot.data!;
            List myLocationList = data['myLocation'];
            bool choice = myLocationList.contains(region);

            return ElevatedButton(
              onPressed: () async {
                if (choice) {
                  myLocationList.remove(region);
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(user!.uid)
                      .update({'myLocation': myLocationList});
                  setState(() {});
                } else if (myLocationList.length >= 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('지역은 2개까지 선택 가능합니다')));
                } else {
                  myLocationList.add(region);
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(user!.uid)
                      .update({'myLocation': myLocationList});
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                primary: choice ? Color(0xFFFF6F61) : Colors.grey[200],
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(80, 40),
              ),
              child: Text(region),
            );
          }
        });
  }
}
