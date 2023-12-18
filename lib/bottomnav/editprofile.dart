import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedInterest = '';
  String selectedRegion = '';

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
              const Text('프로필 편집'),
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
          // 1. 이름 입력 필드
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '이름',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 2. 이름을 입력하는 텍스트 필드
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '이름을 입력하세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // 3. 소개글 입력 필드
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '소개글',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 4. 소개글을 입력하는 텍스트 필드
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: TextFormField(
              maxLines: null, // 세로로 길어질 수 있도록
              decoration: InputDecoration(
                hintText: '소개글을 입력하세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // 5. 관심사 선택
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '관심사',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 6. 관심사 선택 버튼 (이미지와 함께)
          _buildInterestButtons(),

          // 7. 지역 선택
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '지역',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 8. 지역 선택 버튼
          _buildRegionButtons(),

          // 9. 추가 정보 (옵션)
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '추가 정보 (옵션)',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 10. 출석 교회 명 입력 필드
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '출석 교회 명을 입력하세요 (옵션)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // 11. '편집 완료' 버튼
          _buildRoundedButton(context),
        ],
      ),
    );
  }

  Widget _buildInterestButtons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildInterestButton('독서', 'assets/category_reading.png'),
          _buildInterestButton('경제', 'assets/category_economy.png'),
          _buildInterestButton('예술', 'assets/category_art.png'),
          _buildInterestButton('음악', 'assets/category_music.png'),
          _buildInterestButton('운동', 'assets/category_sports.png'),
          _buildInterestButton('직무', 'assets/category_career.png'),
        ],
      ),
    );
  }

  Widget _buildInterestButton(String interest, String iconPath) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedInterest = interest;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedInterest == interest ? Colors.blue : Colors.grey,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: Size(80, 40),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Text(interest),
        ],
      ),
    );
  }

  Widget _buildRegionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildRegionButton('서울'),
          _buildRegionButton('경기 남부'),
          _buildRegionButton('경기 북부'),
          _buildRegionButton('인천'),
        ],
      ),
    );
  }

  Widget _buildRegionButton(String region) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedRegion = region;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedRegion == region ? Colors.blue : Colors.grey,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: Size(80, 40),
      ),
      child: Text(region),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 편집 완료 버튼을 눌렀을 때의 로직을 추가하세요.
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
          '편집 완료',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
