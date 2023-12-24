import 'package:flutter/material.dart';

class PostFeedPage extends StatefulWidget {
  @override
  _PostFeedPageState createState() => _PostFeedPageState();
}

class _PostFeedPageState extends State<PostFeedPage> {
  List<String> meetingList = ['독서 모임', '운동 모임', '찬양 집회']; // 예시 정모 목록
  String selectedMeeting = '';

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
          _buildSectionDescription('사진을 선택하세요.'),
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
        child: Text(
          description,
          style: TextStyle(
            color: Colors.grey,
          ),
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
        // 피드 올리기 버튼을 눌렀을 때의 로직을 추가하세요.
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
