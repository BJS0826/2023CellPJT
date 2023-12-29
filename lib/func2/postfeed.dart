import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../func1/login.dart';

class PostFeedPage extends StatefulWidget {
  final moimID;
  const PostFeedPage({super.key, required this.moimID});

  @override
  _PostFeedPageState createState() => _PostFeedPageState();
}

class _PostFeedPageState extends State<PostFeedPage> {
  List<String> meetingList = ['독서 모임', '운동 모임', '찬양 집회']; // 예시 정모 목록
  String selectedMeeting = '';
  TextEditingController feedContentController = TextEditingController();

  File? _image;

  String generateRandomId(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  Future<void> _addEventToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userName = "";

    if (feedContentController.text.isNotEmpty && selectedMeeting.isNotEmpty) {
      try {
        String randomeID = generateRandomId(20);
        String imageURL;
        final FirebaseStorage _storage = FirebaseStorage.instance;
        Reference ref = _storage.ref().child('feed_images/$randomeID.jpg');
        if (_image != null) {
          await ref.putFile(_image!);
          imageURL = await ref.getDownloadURL();
        } else {
          imageURL =
              "https://firebasestorage.googleapis.com/v0/b/ndproject-743d6.appspot.com/o/user_images%2Flogo.png?alt=media&token=21da4c39-5b63-4a94-9558-4bd5f002fe8c";
        }

        if (imageURL.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("피드 사진을 추가해 주세요"),
            backgroundColor: Colors.blue,
          ));
        } else {
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          DocumentSnapshot userDoc =
              await firestore.collection('user').doc(user!.uid).get();
          userName = userDoc.get('userName');

          Map<String, dynamic> me = {user.uid: userName};

          await FirebaseFirestore.instance
              .collection('feed')
              .doc(randomeID)
              .set({
            'moimId': widget.moimID,
            'writer': me,
            'time': Timestamp.now(),
            'selectedMeeting': selectedMeeting,
            'feedContent': feedContentController.text,
            "feedImage": imageURL,
            "favorite": List<String>,
            "viewNumber": 0
          });

          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("모임 추가 중 오류가 발생했습니다: $e"),
          backgroundColor: Colors.blue,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("유효한 정보를 입력하세요."),
        backgroundColor: Colors.blue,
      ));
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
              const Text('피드 작성'),
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
          _buildSectionTitle('정모 선택'),
          _buildSectionDescription('피드를 남기고자 하는 정모를 선택하세요.'),
          _buildMeetingListView(),
          _buildSectionTitle('사진 첨부'),
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
                      : DecorationImage(image: AssetImage('assets/logo.png')),
                  border: _image != null
                      ? Border.all(width: 1)
                      : Border.all(color: Color(0xFFFFFFFF)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          _buildSectionTitle('피드 내용'),
          _buildTextField('내용을 작성하세요.', maxLines: 5),
          _buildRoundedButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDescription(String description) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 4.0,
          bottom: 4.0,
        ),
        child: Column(
          children: [
            Text(
              description,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, {int? maxLines}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: TextFormField(
        controller: feedContentController,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: meetingList
            .map(
              (meeting) => RadioListTile(
                title: Text(meeting),
                value: meeting,
                groupValue: selectedMeeting,
                onChanged: (value) {
                  setState(() {
                    selectedMeeting = value as String;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (selectedMeeting.length < 2) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("정모를 선택해 주세요"),
            backgroundColor: Colors.blue,
          ));
        } else if (feedContentController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("피드를 입력해 주세요"),
            backgroundColor: Colors.blue,
          ));
        } else {
          _addEventToFirestore();
        }
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
          '피드 올리기',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
