import 'package:cellpjt/appbar/groupsearch.dart';
import 'package:cellpjt/appbar/notification.dart';
import 'package:cellpjt/func2/aboutgroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cellpjt/appbar/creategroup.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  PageController _pageController = PageController(viewportFraction: 0.8);
  String selectedCategory = ''; // 선택된 카테고리를 저장하는 변수

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
        buildAppBarIconButton(Icons.notifications_none, () {
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
        SizedBox(height: 16.0),
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
                  '전체보기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '모임 찾기',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        buildCategoryButtons(),
        Expanded(
          child: FutureBuilder<List<DocumentSnapshot>>(
            future: _fetchGroupsData(selectedCategory),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    var groupsData = snapshot.data! as List<DocumentSnapshot>;
                    print('Number of groups: ${groupsData.length}'); // 디버그용 로그
                    return buildGroupList(groupsData);
                  } else {
                    return Text('No data found');
                  }
                }
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildCategoryButtons() {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      shrinkWrap: true,
      children: [
        _buildCategoryButton('전체보기', 'assets/category_all.png'),
        _buildCategoryButton('독서', 'assets/category_reading.png'),
        _buildCategoryButton('경제', 'assets/category_economy.png'),
        _buildCategoryButton('예술', 'assets/category_art.png'),
        _buildCategoryButton('음악', 'assets/category_music.png'),
        _buildCategoryButton('운동', 'assets/category_sports.png'),
        _buildCategoryButton('직무', 'assets/category_career.png'),
        _buildCategoryButton('기타', 'assets/category_free.png'),
      ],
    );
  }

  Widget _buildCategoryButton(String text, String imagePath) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = text;
              print('Selected category: $selectedCategory');
            });
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
        SizedBox(height: 2.0),
        Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }

  Future<List<DocumentSnapshot>> _fetchGroupsData(String category) async {
    QuerySnapshot querySnapshot;

    if (category.isEmpty || category == '전체보기') {
      // 전체보기인 경우 모든 데이터 가져오기
      querySnapshot = await FirebaseFirestore.instance.collection('Moim').get();
    } else {
      // 특정 카테고리에 대한 데이터 가져오기
      querySnapshot = await FirebaseFirestore.instance
          .collection('Moim')
          .where('category', isEqualTo: category)
          .get();
    }

    // 디버깅을 위해 쿼리 결과를 출력
    querySnapshot.docs.forEach((doc) {
      print('Document ID: ${doc.id}, Data: ${doc.data()}');
    });

    return querySnapshot.docs;
  }

  Widget buildGroupList(List<DocumentSnapshot> groupsData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: groupsData.length,
          itemBuilder: (context, index) {
            var group = groupsData[index].data() as Map<String, dynamic>? ??
                {}; // 수정 부분

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
                      title: Text(group['moimTitle']),
                      subtitle: Text(group['moimIntroduction'],
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AllGroupsPage extends StatefulWidget {
  const AllGroupsPage({super.key});

  @override
  State<AllGroupsPage> createState() => _AllGroupsPageState();
}

class _AllGroupsPageState extends State<AllGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 정모'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Moim').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> moimsData = [];
                snapshot.data!.docs.forEach((doc) {
                  String docId = doc.id;
                  Map<String, dynamic> moimData =
                      doc.data() as Map<String, dynamic>;
                  moimData['id'] = docId;

                  moimsData.add(moimData);
                });

                return ListView.builder(
                  itemCount: moimsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> moim = moimsData[index];
                    String moimID = moim['id'];

                    return ListTile(
                      title: Text('${moim['moimTitle']}'),
                      subtitle: Text('모임소개: ${moim['moimIntroduction']}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutGroupPage(moimID: moimID)));
                      },
                    );
                  },
                );
              } else {
                return Text('No Moim documents found');
              }
            }
          }
        },
      ),
    );
  }
}
