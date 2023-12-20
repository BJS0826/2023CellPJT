import 'package:cellpjt/appbar/groupsearch.dart';
import 'package:cellpjt/appbar/notification.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '셀모임',
      home: Scaffold(
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: 17.0),
        child: const Text('셀모임'),
      ),
      leading: Container(
        padding: EdgeInsets.only(left: 20.0, top: 20.0),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        buildAppBarIconButton(Icons.search, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupSearchPage()),
          );
        }),
        buildAppBarIconButton(Icons.add, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupPage()),
          );
        }),
        buildAppBarIconButton(Icons.notifications, () {
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

  IconButton buildAppBarIconButton(IconData icon, Function onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed as void Function()?,
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 8.0),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '추천 정모',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllGroupsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF6F61),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(
                  '전체 보기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        buildRecommendedGroups(),
        SizedBox(height: 16.0),
        buildCategoryButtons(),
        SizedBox(height: 16.0),
        buildGroupList(),
      ],
    );
  }

  Widget buildRecommendedGroups() {
    return Container(
      height: 200.0,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Card(
              elevation: 2.0,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/meeting_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '추천 정모 $index',
                      style: TextStyle(fontSize: 14.0),
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

  Widget buildCategoryButtons() {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      shrinkWrap: true,
      children: [
        _buildCategoryButton('전체보기', 'assets/category_all.png'),
        _buildCategoryButton('독서', 'assets/category_reading.png'),
        _buildCategoryButton('경제', 'assets/category_economy.png'),
        _buildCategoryButton('예술', 'assets/category_art.png'),
        _buildCategoryButton('음악', 'assets/category_music.png'),
        _buildCategoryButton('운동', 'assets/category_sports.png'),
        _buildCategoryButton('직무', 'assets/category_career.png'),
        _buildCategoryButton('자유', 'assets/category_free.png'),
      ],
    );
  }

  Widget buildGroupList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 2.0,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage('assets/profile_image.jpg'),
                    ),
                    title: Text('모임명 $index'),
                    subtitle: Text('모임 설명 $index',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryButton(String text, String imagePath) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // 해당 카테고리로 이동하는 로직 추가
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Container(
            width: 20.0,
            height: 20.0,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}

class AllGroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 모임'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('모임명 $index'),
              subtitle: Text('모임 설명 $index'),
            );
          },
        ),
      ),
    );
  }
}
