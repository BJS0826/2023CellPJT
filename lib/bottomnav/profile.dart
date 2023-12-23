import 'package:cellpjt/appbar/creategroup.dart';
import 'package:cellpjt/appbar/groupsearch.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/bottomnav/editprofile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '셀모임',
      home: Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 17.0),
        child: const Text('셀모임'),
      ),
      leading: Container(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        buildAppbarIconButton(Icons.search, () {
          // 검색 버튼 페이지 연결
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupSearchPage()),
          );
        }),
        buildAppbarIconButton(Icons.add, () {
          // 글 작성 버튼 페이지 연결
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupPage()),
          );
        }),
        buildAppbarIconButton(Icons.notifications_none, () {
          // 알림 버튼 페이지 연결
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationPage()),
          );
        }),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(16.0),
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
    );
  }

  IconButton buildAppbarIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed as void Function()?,
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 8.0),
    );
  }

  Widget buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildProfileInfo(),
        const SizedBox(height: 16.0),
        buildInterests(),
        const SizedBox(height: 16.0),
        buildLocations(),
        const SizedBox(height: 16.0),
        buildMyGroups(),
        const SizedBox(height: 16.0),
        buildMyMeetings(),
      ],
    );
  }

  Widget buildProfileInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildProfileImageAndName(),
        buildEditProfileButton(),
      ],
    );
  }

  Widget buildProfileImageAndName() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage('assets/profile_image.jpg'),
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '강현규',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '한국의 일론 머스크',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfilePage()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFF6F61), // 버튼 색상을 코랄 블루로 변경
      ),
      child: Text(
        '프로필 편집',
        style: TextStyle(
          color: Colors.white, // 텍스트 색상을 흰색으로 변경
        ),
      ),
    );
  }

  Widget buildInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '관심사',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildInterestList(),
      ],
    );
  }

  Widget buildInterestList() {
    return ListView(
      shrinkWrap: true,
      children: [
        buildInterestItem('운동', 'assets/category_sports.png'),
        buildInterestItem('경제', 'assets/category_economy.png'),
        buildInterestItem('예술', 'assets/category_art.png'),
        buildInterestItem('음악', 'assets/category_music.png'),
        // ... 추가 관심사 아이템
      ],
    );
  }

  Widget buildInterestItem(String interest, String imagePath) {
    return ListTile(
      leading: ClipOval(
        child: Container(
          width: 25.0, // 조절된 원의 크기
          height: 25.0, // 조절된 원의 크기
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(interest),
      onTap: () {
        // 관심사 선택 처리
      },
    );
  }

  Widget buildLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지역',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildLocationList(),
      ],
    );
  }

  Widget buildLocationList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('서울'), // 지역명 또는 선택된 지역
        );
      },
    );
  }

  Widget buildMyGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 모임',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildMyGroupsList(),
      ],
    );
  }

  Widget buildMyGroupsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  title: Text('모임명'),
                  subtitle: Text('1/20'), // 인원 수 표시
                ),
                // ... 추가 정보 (모임 인원 등)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMyMeetings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 정모',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        buildMyMeetingsCarousel(),
      ],
    );
  }

  Widget buildMyMeetingsCarousel() {
    return Container(
      height: 100.0, // 높이는 100.0으로 유지
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9, // 이미지의 가로 세로 비율
                    child: Image.asset(
                      'assets/meeting_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '정모명과 날짜',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
