import 'dart:io';

import 'package:cellpjt/bottomnav/mainfeed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool showSpinner = false;

  File? _image;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool imageCheck = false;

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
        imageCheck = true;
        setState(() {
          _image = _image;
          picV = true;
          picColor = Colors.green;
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

  String userName = "";
  String userEmail = "";
  String userPw = "";

  void pickImage(File image) {
    _image = image;
  }

  final TextEditingController _emailRegister = TextEditingController();
  final TextEditingController _pwRegister = TextEditingController();
  final TextEditingController _nameRegister = TextEditingController();
  bool picV = false;
  bool emailV = false;
  bool pwV = false;
  bool nameV = false;
  var picColor = Colors.red;
  var emailColor = Colors.red;
  var pwColor = Colors.red;
  var nameColor = Colors.red;

  Future<void> _signUp(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailRegister.text,
        password: _pwRegister.text,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // 이미지를 Firebase Storage에 업로드
        Reference ref = _storage.ref().child('user_images/$uid.jpg');

        await ref.putFile(_image!);

        // 다운로드 URL 가져오기
        String imageURL = await ref.getDownloadURL();

        // 사용자 정보를 Firestore 또는 Realtime Database에 저장 (예: Firestore)
        // 여기에서는 예시로 Firestore를 사용하는 방법을 보여줍니다.
        // Firestore에 사용자 정보 저장
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'email': _emailRegister.text,
          'userName': _nameRegister.text,
          'picked_image': imageURL,
        });

        // 회원가입 성공 시 작업 수행
        // 예: 다음 화면으로 이동
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainFeedPage()));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.blue,
        ));
      }
      // 회원가입 실패 시 예외 처리
      // 예: 오류 메시지를 보여주거나 적절한 처리를 진행
    }
  }

  @override
  void dispose() {
    _emailRegister.dispose();
    _pwRegister.dispose();
    _nameRegister.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 17.0),
          child: Row(
            children: [
              SizedBox(width: 8.0), // 아이콘과 텍스트 사이의 간격
              const Text('회원가입'),
            ],
          ),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _getImage,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                '프로필 사진',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              if (picV)
                                Text(
                                  "  V",
                                  style: TextStyle(
                                      color: picColor,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '이메일',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      if (emailV)
                        Text(
                          "  V",
                          style: TextStyle(
                              color: emailColor, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _emailRegister,
                  onChanged: (value) {
                    setState(() {
                      if (value!.isNotEmpty) {
                        emailV = true;
                        emailColor = Colors.red;
                        if (value.length > 6 &&
                            value.contains("@") &&
                            value.contains(".")) {
                          emailColor = Colors.green;
                        }
                      } else {
                        emailV = false;
                      }
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: '이메일 형식으로 입력하세요.',

                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0), // 여백을 조절
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '비밀번호',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      if (pwV)
                        Text(
                          "  V",
                          style: TextStyle(
                              color: pwColor, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _pwRegister,
                  onChanged: (value) {
                    setState(() {
                      if (value!.isNotEmpty) {
                        pwV = true;
                        pwColor = Colors.red;
                        if (value.length >= 7) {
                          pwColor = Colors.green;
                        }
                      } else {
                        pwV = false;
                      }
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '7자 이상 입력하세요.',
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '이름',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      if (nameV)
                        Text(
                          "  V",
                          style: TextStyle(
                              color: nameColor, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameRegister,
                  onChanged: (value) {
                    setState(() {
                      if (value!.isNotEmpty) {
                        nameV = true;
                        nameColor = Colors.red;
                        if (value.length >= 2) {
                          nameColor = Colors.green;
                        }
                      } else {
                        nameV = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: '2자 이상 입력하세요.',
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6F61), // 헥사 코드 #FF6F61 (코랄 핑크)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPrimary: Colors.white, // 텍스트 색상을 흰색으로 지정
                      ),
                      onPressed: () {
                        if (!imageCheck) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("프사를 넣어주세요"),
                            backgroundColor: Colors.blue,
                          ));
                        } else if (picColor == Colors.green &&
                            emailColor == Colors.green &&
                            pwColor == Colors.green &&
                            nameColor == Colors.green) {
                          _signUp(context);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("회원가입 실패"),
                            backgroundColor: Colors.blue,
                          ));
                        }
                      },
                      child: Text('회원가입'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
