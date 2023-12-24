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
          _buildTextField('이름', '이름을 입력하세요.'),
          _buildTextField('소개글', '소개글을 입력하세요.', maxLines: 5),
          _buildInterestSection(),
          _buildRegionSection(),
          _buildTextField('출석 교회 명', '출석 교회 명을 입력하세요 (옵션)'),
          _buildRoundedButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hintText, {int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 4.0),
          child: TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        SizedBox(height: 8.0),
        _buildInterestButtons(),
        SizedBox(height: 16.0),
      ],
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
          _buildInterestButton('기타', 'assets/category_free.png')
        ],
      ),
    );
  }

  Widget _buildInterestButton(String interest, String iconPath) {
    return Container(
      width: 110, // 원하는 가로 크기 지정
      height: 40, // 원하는 세로 크기 지정
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedInterest = interest;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: selectedInterest == interest
              ? Color(0xFFFF6F61)
              : Colors.grey[200],
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(interest),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        _buildRegionButtons(),
      ],
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
          _buildRegionButton('부산'),
          _buildRegionButton('그 외'),
          _buildRegionButton('온라인'),
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
        primary:
            selectedRegion == region ? Color(0xFFFF6F61) : Colors.grey[200],
        onPrimary: Colors.black,
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
