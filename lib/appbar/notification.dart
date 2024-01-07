import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '알림',
      home: Scaffold(
        appBar: AppBar(
          title: Text('알림'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: Text(
                '현재 이 기능은 아직 개발 중 입니다',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // 첫 번째 알림
            _buildNotificationItem(
              title: '정모가 곧 시작됩니다.',
              subtitle: '정모명',
              time: '오늘 오후 8시',
              unread: true,
            ),
            // 두 번째 알림
            _buildNotificationItem(
              title: '정모 후기를 작성해 주세요.',
              subtitle: '정모명',
              time: '12월 1일',
              unread: false,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFFFF6F61), // 코랄 핑크
          child: Container(
            height: 60.0,
            child: TextButton(
              onPressed: () {
                // '모두 읽음 표시' 버튼 동작 추가
              },
              child: Text(
                '모두 읽음 표시',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required bool unread,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: unread ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            SizedBox(height: 4.0),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Icon(
          unread ? Icons.circle : Icons.check_circle,
          color: unread ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
