import 'package:cellpjt/func1/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  String selectedInterest = '독서';
  String selectedLocation = '서울';
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  int moimLimit = 10;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;

  // 랜덤 ID를 생성하는 함수
  String generateRandomId(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  Future<void> _addEventToFirestore() async {
    String groupTitle = groupNameController.text;
    String groupIntroduction = groupDescriptionController.text;
    DateTime now = DateTime.now();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = "";
    int point = 0;
    List<String> moimList = [];
    List<dynamic> moimSchedule = [];
    List<String> oonYoungJin = [];
    String userName = "";

    if (user != null) {
      uid = user.uid;
      moimList.add(uid);
      oonYoungJin.add(uid);
    } else {
      // 사용자가 로그인되어 있지 않은 경우 로그아웃하고 로그인 페이지로 이동
      auth.signOut().then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }

    if (groupTitle.isNotEmpty && groupIntroduction.isNotEmpty) {
      try {
        String randomeID = generateRandomId(20);
        String imageURL;

        Reference ref = _storage.ref().child('Moim_images/$randomeID.jpg');
        if (_image != null) {
          await ref.putFile(_image!);
          imageURL = await ref.getDownloadURL();
        } else {
          imageURL =
              "https://firebasestorage.googleapis.com/v0/b/ndproject-743d6.appspot.com/o/user_images%2Flogo.png?alt=media&token=21da4c39-5b63-4a94-9558-4bd5f002fe8c";
        }

        if (imageURL.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("모임 사진을 추가해 주세요"),
            backgroundColor: Colors.blue,
          ));
        } else {
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          DocumentSnapshot userDoc =
              await firestore.collection('user').doc(user!.uid).get();
          userName = userDoc.get('userName');

          Map<String, dynamic> moimLeaderData = {uid: userName};

          await FirebaseFirestore.instance
              .collection('Moim')
              .doc(randomeID)
              .set({
            'moimTitle': groupTitle,
            'moimLocation': selectedLocation,
            "moimIntroduction": groupIntroduction,
            'moimLimit': moimLimit,
            'createdTime': now,
            "moimLeader": moimLeaderData,
            "oonYoungJinList": moimLeaderData,
            "moimPoint": point,
            "boardID": DateTime.now().millisecondsSinceEpoch,
            "moimMembers": moimLeaderData,
            "moimSchedule": moimSchedule,
            "moimCategory": selectedInterest,
            "moimImage": imageURL
          });

          await FirebaseFirestore.instance.collection('user').doc(uid).update({
            'myMoimList.$randomeID': now,
          });

          print('모임이 성공적으로 추가되었습니다!');
          Navigator.pop(context);
        }
      } catch (e) {
        print('모임 추가 중 오류가 발생했습니다: $e');
      }
    } else {
      print('유효한 정보를 입력하세요.');
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 700,
        maxHeight: 700,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets: const [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        _image = await convertCroppedFileToFile(croppedFile);

        setState(() {
          _image = _image;
        });
      }
    }
  }

  Future<File> convertCroppedFileToFile(CroppedFile croppedFile) async {
    final tempDir = await getTemporaryDirectory();
    final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final File tempFile = File('${tempDir.path}/$uniqueFileName.jpg');

    final croppedBytes = await croppedFile.readAsBytes();
    await tempFile.writeAsBytes(croppedBytes);

    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모임 생성'),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 모임 이미지 UI
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '모임 이미지',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          image: _image != null
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(_image!),
                                )
                              : DecorationImage(
                                  image: AssetImage('assets/logo.png')),
                          border: _image != null
                              ? Border.all(width: 1)
                              : Border.all(color: Color(0xFFFFFFFF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // 모임명 UI
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '모임명',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      hintText: '모임명을 입력하세요.',
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // 모임 소개 UI
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '모임 소개',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: TextField(
                      maxLines: 5,
                      controller: groupDescriptionController,
                      decoration: InputDecoration(
                        hintText: '모임 소개를 입력하세요.',
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // 관심사 드롭다운 UI
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '카테고리 :   ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedInterest,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedInterest = newValue!;
                            });
                          },
                          items: <String>[
                            '독서',
                            '경제',
                            '예술',
                            '음악',
                            '운동',
                            '직무',
                            '기타'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // 지역 드롭다운 UI
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '지역 :    ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedLocation,
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
                            '부산',
                            '그 외',
                            '온라인'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // 모임 인원 NumberPicker UI
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '모임 인원 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        NumberPicker(
                          textStyle: TextStyle(fontSize: 12),
                          itemCount: 3,
                          itemHeight: 30,
                          minValue: 10,
                          maxValue: 50,
                          step: 10,
                          haptics: true,
                          value: moimLimit,
                          onChanged: (value) {
                            setState(() {
                              moimLimit = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 모임 생성 버튼 UI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFF6F61),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          _addEventToFirestore();
                        },
                        child: Text('모임 생성'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
