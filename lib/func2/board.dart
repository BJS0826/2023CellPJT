import 'package:cellpjt/func2/board_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  final moimID;
  const BoardPage({super.key, required this.moimID});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "전체보기",
                  style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "공지",
                  style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "가입인사",
                  style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "모임후기",
                  style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "자유",
                  style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('board')
                  .doc(widget.moimID)
                  .collection("boardDetail")
                  // .where('boardCategory', isEqualTo: '공지')
                  .orderBy('createdTime', descending: false)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // 데이터 로딩 중에 보여줄 UI
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> boardTotalDatas =
                          []; // Moim 문서 데이터를 저장할 리스트

                      // 모든 Moim 문서의 ID와 데이터를 가져와 리스트에 추가
                      snapshot.data!.docs.forEach((doc) {
                        String docId = doc.id;
                        Map<String, dynamic> moimData =
                            doc.data() as Map<String, dynamic>;
                        moimData['id'] = docId; // 각 문서의 ID를 데이터에 추가
                        boardTotalDatas.add(moimData);
                      });

                      return ListView.builder(
                        itemCount: boardTotalDatas.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> boardTotalData =
                              boardTotalDatas[index];

                          // 여기서 각 Moim 데이터를 사용하여 UI를 업데이트합니다.
                          // 예를 들어, 각 Moim의 title을 리스트로 출력하는 방식으로 보여줍니다.
                          return _buildMeetingItem(
                            imagePath: 'assets/meeting_image.jpg',
                            name: boardTotalData["writer"],
                            content: boardTotalData["content"],
                          );
                        },
                      );
                    } else {
                      return Text('No Moim documents found');
                    }
                  }
                }
              },
            ),
          ),

          // ListView.builder(
          //               padding: EdgeInsets.all(16.0),
          //               itemCount: 2,
          //               itemBuilder: (context, index) {
          //   return
          // _buildMeetingItem(
          //     imagePath: 'assets/meeting_image.jpg',
          //     name: '배준식',
          //     content: '오늘은 모임이 정말 즐거웠어요!',
          //   );
          //               },
          //             ),

          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.all(16.0),
          //     children: [
          //       _buildMeetingItem(
          //         imagePath: 'assets/meeting_image.jpg',
          //         name: '배준식',
          //         content: '오늘은 모임이 정말 즐거웠어요!',
          //       ),
          //       _buildMeetingItem(
          //         imagePath: 'assets/meeting_image.jpg',
          //         name: '강현규',
          //         content: '다음에도 이런 모임이 있으면 좋겠네요.',
          //       ),
          //       _buildMeetingItem(
          //         imagePath: 'assets/meeting_image.jpg',
          //         name: '배예은',
          //         content: '다들 수고하셨습니다!',
          //       ),
          //       // 다른 정모 항목 추가
          //       // ...
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildCategoryButton(String text) {
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
        // 특정 페이지로 이동하는 코드를 여기에 추가
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BoardPostPage(moimID: widget.moimID);
            }, // YourDestinationPage는 이동하고자 하는 페이지의 클래스명
          ),
        );
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFF6F61), // 코랄 핑크 색상
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
