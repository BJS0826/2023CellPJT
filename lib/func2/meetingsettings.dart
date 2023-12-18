import 'package:flutter/material.dart';

class MeetingSettingsPage extends StatefulWidget {
  final String meetingName;

  MeetingSettingsPage({required this.meetingName});

  @override
  _MeetingSettingsPageState createState() => _MeetingSettingsPageState();
}

class _MeetingSettingsPageState extends State<MeetingSettingsPage> {
  List<MeetingSettingItem> meetingSettings = [
    MeetingSettingItem('설정1', Icons.settings),
    MeetingSettingItem('설정2', Icons.settings),
    MeetingSettingItem('설정3', Icons.settings),
  ]; // 모임 설정 목록

  MeetingSettingItem? selectedSetting;

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
              Text('설정'),
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
          // 1. '모임 설정' 열
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '모임 설정',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 2. '원하는 설정을 선택하세요.' 텍스트
          ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Text(
                '추후 구현 예정',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // 3. 설정 선택을 위한 리스트뷰
          _buildSettingListView(),

          // 7. '저장하기' 버튼
          _buildRoundedButton(context),
        ],
      ),
    );
  }

  Widget _buildSettingListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: meetingSettings
            .map(
              (setting) => Card(
                child: ListTile(
                  title: Text(setting.name),
                  leading: Icon(setting.icon),
                  onTap: () {
                    setState(() {
                      selectedSetting = setting;
                    });
                  },
                  selected: selectedSetting == setting,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 저장하기 버튼을 눌렀을 때의 로직을 추가하세요.
        if (selectedSetting != null) {
          // 선택된 설정에 대한 처리
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
          '저장하기',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MeetingSettingItem {
  final String name;
  final IconData icon;

  MeetingSettingItem(this.name, this.icon);
}
