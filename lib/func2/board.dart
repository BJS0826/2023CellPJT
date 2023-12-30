import 'package:cellpjt/func2/board_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  final String? moimID;

  const BoardPage({Key? key, required this.moimID}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedCategory = '';

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
                } else if (snapshot.hasError) {
                  return Text('데이터를 불러올 수 없습니다.');
                } else if (snapshot.hasData && snapshot.data != null) {
                  var userMemberDatas =
                      snapshot.data! as List<DocumentSnapshot>;
                  return buildBoardList(userMemberDatas);
                } else {
                  return Text('No data found');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchBoardData(String category) async {
    print("Fetching data for category: $category");
    QuerySnapshot querySnapshot;

    if (category.isEmpty || category == '전체보기') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('board')
          .doc(widget.moimID)
          .collection("boardDetail")
          .orderBy('createdTime', descending: true)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('board')
          .doc(widget.moimID)
          .collection("boardDetail")
          .where('category', isEqualTo: category)
          .get();
    }

    return querySnapshot.docs;
  }

  Widget buildBoardList(List<DocumentSnapshot> userMemberDatas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: userMemberDatas.length,
        itemBuilder: (context, index) {
          var userMember =
              userMemberDatas[index].data() as Map<String, dynamic>? ?? {};
          String writer = userMember?['writer'] ?? '';
          String content = userMember?['content'] ?? '';

          return GestureDetector(
            onTap: () {
              _onPostClicked(userMemberDatas[index]);
            },
            child: Container(
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
                        image: AssetImage('assets/meeting_image.jpg'),
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      writer,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryButton(String text, String category) {
    return ElevatedButton(
      onPressed: () {
        print("Selected category: $category");
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedCategory == category ? Colors.blue : Colors.white,
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

  void _onPostClicked(DocumentSnapshot postSnapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          // 새로운 페이지로 전달할 게시물 정보 설정
          Map<String, dynamic> postData =
              postSnapshot.data() as Map<String, dynamic>? ?? {};

          return PostDetailPage(postData: postData);
        },
      ),
    );
  }
}

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> postData;

  const PostDetailPage({Key? key, required this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세보기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '작성자: ${postData['writer']}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Divider(
              // 추가: 구분선
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(height: 8.0),
            Text(
              '내용:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              postData['content'],
              style: TextStyle(fontSize: 16.0),
            ),
            // 필요한 다른 정보들을 표시하도록 추가
          ],
        ),
      ),
    );
  }
}
