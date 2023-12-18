import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoimJangModi extends StatefulWidget {
  final moimID;
  final MoimJang;
  const MoimJangModi({super.key, required this.moimID, required this.MoimJang});

  @override
  State<MoimJangModi> createState() => _MoimJangModiState();
}

class _MoimJangModiState extends State<MoimJangModi> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;

  List<String> oonyoungjinList = [];
  late String name;

  Future<List<String>> managementsData(oonyoungjinList) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Moim').doc(widget.moimID).get();
    List<dynamic> c = snapshot["oonYoungJin"];
    print("돌아가는 숫자는 :  ${c.length}");
    List<String> oonyoungjinList = [];
    for (String userID in c) {
      DocumentSnapshot<Map<String, dynamic>> snapshot2 =
          await _firestore.collection('user').doc(userID).get();

      if (snapshot2.exists) {
        String str = snapshot2.data()?['userName'];

        print("str == $str");
        oonyoungjinList.add(str); // 사용자 이름을 oonyoungjinList에 추가
      }
    }
    print("str == $oonyoungjinList");

    return oonyoungjinList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.MoimJang;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: managementsData(oonyoungjinList),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('데이터를 불러올 수 없습니다.'),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                List<String>? managements = snapshot.data;

                return Scaffold(
                  appBar: AppBar(
                    title: Text("모임장 양도"),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("모임장 : $name"),
                      SizedBox(
                        width: 40,
                      ),
                      Text("모임장은 운영진만 선택 가능합니다."),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("모임장 양도 선택 : "),
                          DropdownButton<String>(
                            onChanged: (String? newValue) {
                              setState(() {
                                name = newValue!;
                              });
                            },
                            items: managements
                                ?.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {},
                            child: Text("모임장양도"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("취소"),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            }
          }
          return Scaffold(
            body: Center(
              child: Text('데이터를 불러올 수 없습니다.'),
            ),
          );
        });
  }
}
