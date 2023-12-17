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
  String selectedInterest = '독서'; // 기본 관심사
  String selectedLocation = '서울'; // 기본 지역
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController groupMembersController = TextEditingController();
  int moimLimit = 10;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _image;

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

    if (user != null) {
      uid = user.uid;
      moimList.add(uid);
      oonYoungJin.add(uid);
    } else {
      auth.signOut().then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }

    if (groupTitle.isNotEmpty && groupIntroduction.isNotEmpty) {
      try {
        String generateRandomId(int length) {
          const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
          final random = Random();
          return String.fromCharCodes(Iterable.generate(
            length,
            (_) => chars.codeUnitAt(random.nextInt(chars.length)),
          ));
        }

        String randomeID = generateRandomId(10);
        Reference ref = _storage.ref().child('Moim_images/$randomeID.jpg');
        await ref.putFile(_image!);
        String imageURL = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('Moim').doc(randomeID).set({
          'moimTitle': groupTitle,
          'moimLocation': selectedLocation,
          "moimIntroduction": groupIntroduction,
          'moimLimit': moimLimit,
          'createdTime': now,
          "moimJang": uid,
          "oonYoungJin": oonYoungJin,
          "moimPoint": point,
          "boardID": DateTime.now().millisecondsSinceEpoch,
          "moimMembers": moimList,
          "moimSchedule": moimSchedule,
          "moimCategory": selectedInterest,
          "moimImage": imageURL
        });

        print('모임이 성공적으로 추가되었습니다!');
        Navigator.pop(context);
        // 추가되었으니 필요한 다른 작업을 수행하거나 화면을 닫을 수 있습니다.
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

    // Get the cropped image file as bytes
    final croppedBytes = await croppedFile.readAsBytes();

    // Write the cropped image bytes to the new file
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
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
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
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextField(
                      maxLines: null,
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '관심사 :   ',
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
                            '자유'
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFF6F61), // 코랄 핑크
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPrimary: Colors.white, // 텍스트 색상
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
