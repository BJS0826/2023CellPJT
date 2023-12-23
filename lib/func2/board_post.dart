import 'package:flutter/material.dart';

class BoardPostPage extends StatefulWidget {
  const BoardPostPage({Key? key}) : super(key: key);

  @override
  _BoardPostPageState createState() => _BoardPostPageState();
}

class _BoardPostPageState extends State<BoardPostPage> {
  String selectedCategory = ''; // 선택된 카테고리를 저장하는 변수

  @override
  Widget build(BuildContext context) {
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
        // 카테고리 선택 시 상태를 업데이트하고 UI를 갱신합니다.
        setState(() {
          selectedCategory = text;
        });
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
        // 글 올리기 버튼을 눌렀을 때의 로직을 추가하세요.
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
