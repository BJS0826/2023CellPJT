import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key});

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
            child: _buildRoundedButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryButton('전체'),
              _buildCategoryButton('공지'),
              _buildCategoryButton('가입인사'),
              _buildCategoryButton('모임 후기'),
              _buildCategoryButton('자유'),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildMeetingItem(
                  imagePath: 'assets/meeting_image.jpg',
                  name: '배준식',
                  content: '오늘은 모임이 정말 즐거웠어요!',
                ),
                _buildMeetingItem(
                  imagePath: 'assets/meeting_image.jpg',
                  name: '강현규',
                  content: '다음에도 이런 모임이 있으면 좋겠네요.',
                ),
                _buildMeetingItem(
                  imagePath: 'assets/meeting_image.jpg',
                  name: '배예은',
                  content: '다들 수고하셨습니다!',
                ),
                // 다른 정모 항목 추가
                // ...
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: SizedBox(
        width: 70.0,
        height: 40.0,
        child: ElevatedButton(
          onPressed: () {},
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
        ),
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

  Widget _buildRoundedButton() {
    return ElevatedButton(
      onPressed: () {},
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
