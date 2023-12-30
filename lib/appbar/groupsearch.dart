import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupSearchPage extends StatefulWidget {
  const GroupSearchPage({super.key});

  @override
  State<GroupSearchPage> createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends State<GroupSearchPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? subCollectionData;
  TextEditingController searchController = TextEditingController();

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
    return
        // Scaffold(
        //     appBar: AppBar(),
        //     body: FutureBuilder(
        //       future:
        //           FirebaseFirestore.instance.collection('totalMoimSchedule').get(),
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Center(child: Text('대기'));
        //         }
        //         if (!snapshot.hasData) {
        //           return Center(child: Text('데이터가 없습니다.'));
        //         } else {
        //           var data = snapshot.data!;
        //           List<String> docID = [];

        //           for (var doc in data.docs) {
        //             docID.add(doc.id);

        //             // FirebaseFirestore.instance
        //             //     .collection('totalMoimSchedule')
        //             //     .doc(docID)
        //             //     .collection('subcollection')
        //             //     .get()
        //             //     .then((subCollectionSnapshot) {
        //             //   if (subCollectionSnapshot.docs.isNotEmpty) {
        //             //     // 하위 컬렉션 데이터 사용하기
        //             //     subCollectionData = subCollectionSnapshot.docs;

        //             //     print('${subCollectionData}');
        //             //   }
        //             // }).catchError((error) {
        //             //   // 에러 처리
        //             //   print('하위 컬렉션 가져오기 에러: $error');
        //             // });
        //           }

        //           // 여기서 UI 빌드 또는 처리를 반환할 수 있습니다.

        //           return SizedBox(
        //             height: 400,
        //             width: MediaQuery.of(context).size.width,
        //             child: ListView.builder(
        //                 itemCount: docID.length,
        //                 itemBuilder: (context, index) {
        //                   return ListTile(
        //                     title: Text(docID[index]),
        //                   );
        //                 }),
        //           );
        //         }
        //       },
        //     ));

        Scaffold(
      appBar: AppBar(
        title: Text('모임 검색'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                '검색어',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요.',
                filled: true,
                fillColor: Color(0xFFFFFFFF),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6F61), // 코랄 핑크
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPrimary: Colors.white, // 텍스트 색상
                      ),
                      onPressed: () {
                        // 모임 검색 버튼
                      },
                      child: Text('모임 검색'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
