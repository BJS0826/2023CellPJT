import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BoardPostPage extends StatefulWidget {
  final moimID;
  const BoardPostPage({Key? key, required this.moimID}) : super(key: key);

  @override
  _BoardPostPageState createState() => _BoardPostPageState();
}

class _BoardPostPageState extends State<BoardPostPage> {
  String selectedCategory = '가입인사'; // 선택된 카테고리를 저장하는 변수
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController contentController = TextEditingController();
  bool management = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;
    managementCheck();
  }

  Future<bool> managementCheck() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("Moim").doc(widget.moimID).get();
    late Future<DocumentSnapshot<Map<String, dynamic>>> moimData;
    setState(() {
      moimData = Future.value(snapshot);
      Map<String, dynamic> oonYougJinList = snapshot.data()!["oonYoungJinList"];
      for (String id in oonYougJinList.keys) {
        if (id.contains(user!.uid)) {
          management = true;
        } else {
          management = false;
        }
      }
    });

    return false;
  }

  Future addBoard() async {
    String content = contentController.text;
    DateTime now = DateTime.now();
    String userName = "";
    String writerImage = '';

    await FirebaseFirestore.instance
        .collection('user') // 컬렉션 이름
        .doc(user!.uid) // 문서 ID
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // 'userName' 필드에 접근하여 값 가져오기
        userName =
            documentSnapshot.get('userName'); // 'userName'은 실제 필드명에 맞게 수정하세요.
        writerImage = documentSnapshot.get('picked_image');
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      // 오류 처리
      print("Error getting document: $error");
    });

    if (!management && selectedCategory.contains("공지")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("관리자만 공지 등록이 가능합니다"),
        backgroundColor: Colors.blue,
      ));
    } else {
      if (content.length <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("내용을 입력하세요"),
          backgroundColor: Colors.blue,
        ));
      } else {
        await _firestore
            .collection("board")
            .doc(widget.moimID)
            .collection("boardDetail")
            .add({
          "content": content,
          "category": selectedCategory,
          'createdTime': now,
          "writer": userName,
          "writerId": user!.uid,
          "writerImage": writerImage
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("업데이트 완료"),
          backgroundColor: Colors.blue,
        ));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('$user');
    return Scaffold(
      appBar: AppBar(
        title: Text('글 작성'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 첫 번째 Row - 카테고리
            Text(
              '카테고리',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // 두 번째 Row - 카테고리 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton(context, '공지'),
                _buildCategoryButton(context, '가입인사'),
                _buildCategoryButton(context, '모임 후기'),
                _buildCategoryButton(context, '자유'),
              ],
            ),
            SizedBox(height: 16.0),
            // 세 번째 Row - 내용
            Text(
              '내용',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // 네 번째 Row - 내용을 입력하는 텍스트 필드
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '내용을 입력하세요.',
              ),
            ),
            SizedBox(height: 16.0),
            // 마지막 Row - 글 올리기 버튼
            _buildRoundedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        if (!management) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("관리자만 공지 등록이 가능합니다"),
            backgroundColor: Colors.blue,
          ));
        } else {
          setState(() {
            selectedCategory = text;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: selectedCategory == text ? Color(0xFFFF6F61) : Colors.white,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.white, // 선택된 버튼의 테두리 색상
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        addBoard();
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
          '글 올리기',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
