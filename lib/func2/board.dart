import 'package:cellpjt/func2/board_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  final moimID;
  const BoardPage({super.key, required this.moimID});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedCategory = ''; // 선택된 카테고리를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildRoundedButton(context),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryButton("전체보기", ''),
              _buildCategoryButton("공지", '공지'),
              _buildCategoryButton("가입인사", '가입인사'),
              _buildCategoryButton("모임후기", '모임후기'),
              _buildCategoryButton("자유", '자유'),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _fetchBoardData(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                          String userName = userMemberDatas[index]['writer'];
                          String content = userMemberDatas[index]['content'];

                          return _buildMeetingItem(
                            imagePath: 'assets/meeting_image.jpg',
                            name: userName,
                            content: content,
                          );
                        },
                      );
                    } else {
                      return Text('No data found');
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchBoardData(String category) async {
    QuerySnapshot querySnapshot;

    if (category.isEmpty) {
      // 전체보기인 경우 모든 데이터 가져오기
      querySnapshot = await FirebaseFirestore.instance
          .collection('board')
          .doc(widget.moimID)
          .collection("boardDetail")
          .orderBy('createdTime', descending: false)
          .get();
    } else {
      // 특정 카테고리에 대한 데이터 가져오기
      querySnapshot = await FirebaseFirestore.instance
          .collection('board')
          .doc(widget.moimID)
          .collection("boardDetail")
          .where('category', isEqualTo: category)
          .orderBy('createdTime', descending: false)
          .get();
    }

    return querySnapshot.docs;
  }

  Widget _buildCategoryButton(String text, String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMeetingItem({
    required String imagePath,
    required String name,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipOval(
              child: Image(
                image: AssetImage(imagePath),
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BoardPostPage(moimID: widget.moimID);
            },
          ),
        );
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFF6F61),
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '글 작성',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
