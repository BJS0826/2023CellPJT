import 'package:flutter/material.dart';

class MeetingSchedulePage extends StatelessWidget {
  const MeetingSchedulePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정모 일정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.2),
            height: 350,
            width: 350,
            child: Center(
              child: Text(
                '캘린더 모듈',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                MeetingItem(
                  imagePath: 'assets/meeting_image.jpg',
                  name: '23년 CM 리더 모임',
                  date: '12. 17(일)',
                  location: '베다니교회',
                ),
                Divider(color: Colors.grey), // 리스트 간의 회색 줄
                MeetingItem(
                  imagePath: 'assets/meeting_image.jpg',
                  name: '두 번째 모임',
                  date: '12. 18(월)',
                  location: '두번째 장소',
                ),
                Divider(color: Colors.grey), // 리스트 간의 회색 줄
                MeetingItem(
                  imagePath: 'assets/meeting_image.jpg',
                  name: '세 번째 모임',
                  date: '12. 19(화)',
                  location: '세번째 장소',
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
}

class MeetingItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String date;
  final String location;

  const MeetingItem({
    required this.imagePath,
    required this.name,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image(
          image: AssetImage(imagePath),
          width: 50.0,
          height: 50.0,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '날짜: $date',
              ),
            ],
          ),
          Text(
            '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            location,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        // 정모 항목을 눌렀을 때의 동작 추가
      },
    );
  }
}
