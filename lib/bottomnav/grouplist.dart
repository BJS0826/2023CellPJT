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
        // 추천 정모 리스트 뷰 부분
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

        buildGroupList(),
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

  Widget buildGroupList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
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
        SizedBox(height: 2.0),
        Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}

class AllGroupsPage extends StatefulWidget {
  const AllGroupsPage({super.key});

  @override
  State<AllGroupsPage> createState() => _AllGroupsPageState();
}

class _AllGroupsPageState extends State<AllGroupsPage> {
  List<String> moimIds = [];
  List<DocumentSnapshot<Map<String, dynamic>>> datasList = [];

  // Future<List<DocumentSnapshot<Map<String, dynamic>>>> getIds() async {
  //   FirebaseFirestore.instance
  //       .collection('Moim') // 'moims'는 Moim 컬렉션명입니다. 본인의 컬렉션명에 맞게 변경해주세요.
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     if (querySnapshot != null) {
  //       querySnapshot.docs.forEach((doc) {
  //         moimIds.add(doc.id);
  //       });

  //       // 모든 Moim 문서의 ID를 출력하거나 사용할 수 있습니다.
  //       moimIds.forEach((id) async {
  //         DocumentSnapshot<Map<String, dynamic>> data =
  //             await FirebaseFirestore.instance.collection("Moim").doc(id).get();
  //         datasList.add(data);
  //       });
  //     } else {
  //       print('No Moim documents found.');
  //     }
  //   }).catchError((error) {
  //     // 오류 처리
  //     print("Error getting Moim documents: $error");
  //   });

  //   return datasList;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
            return CircularProgressIndicator(); // 데이터 로딩 중에 보여줄 UI
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> moimsData =
                    []; // Moim 문서 데이터를 저장할 리스트

                // 모든 Moim 문서의 ID와 데이터를 가져와 리스트에 추가
                snapshot.data!.docs.forEach((doc) {
                  String docId = doc.id;
                  Map<String, dynamic> moimData =
                      doc.data() as Map<String, dynamic>;
                  moimData['id'] = docId; // 각 문서의 ID를 데이터에 추가
                  moimsData.add(moimData);
                });

                return ListView.builder(
                  itemCount: moimsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> moim = moimsData[index];
                    String moimID = moim['id'];

                    // 여기서 각 Moim 데이터를 사용하여 UI를 업데이트합니다.
                    // 예를 들어, 각 Moim의 title을 리스트로 출력하는 방식으로 보여줍니다.
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
