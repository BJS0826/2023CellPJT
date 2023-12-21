import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoimJangModi extends StatefulWidget {
  final moimID;

  final Map<String, dynamic> Leader;
  final Map<String, dynamic> oonYoungJinList;
  const MoimJangModi(
      {super.key,
      required this.moimID,
      required this.Leader,
      required this.oonYoungJinList});

  @override
  State<MoimJangModi> createState() => _MoimJangModiState();
}

class _MoimJangModiState extends State<MoimJangModi> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late String name;

  Future<void> updateLeaderField() async {
    try {
      // 예를 들어 'moimID'라는 Moim 문서의 ID를 가정합니다.

      // 업데이트할 Moim 문서의 레퍼런스 가져오기
      DocumentReference moimRef =
          firestore.collection('Moim').doc(widget.moimID);

      String findKeyWithValue(Map<String, dynamic> map, dynamic targetValue) {
        String foundKey = "";

        map.forEach((key, value) {
          if (value == targetValue) {
            foundKey = key;
          }
        });

        if (foundKey != null) {
          print('찾은 키: $foundKey');
        } else {
          print('해당 값의 키를 찾을 수 없습니다.');
        }
        return foundKey;
      }

      String keys = findKeyWithValue(widget.oonYoungJinList, name);

      // 업데이트할 데이터 생성
      Map<String, dynamic> updatedData = {
        'moimLeader': {keys: name},
      };

      // Moim 문서의 'leader' 필드 업데이트
      await moimRef.update(updatedData);
      print(" $name : $keys ");
      print('Moim 문서의 "leader" 필드가 업데이트되었습니다.');
    } catch (e) {
      print('Moim 문서 "leader" 필드 업데이트 오류: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.Leader.values.first;
  }

  @override
  Widget build(BuildContext context) {
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
                items: widget.oonYoungJinList.values
                    .toList()
                    .map<DropdownMenuItem<String>>((dynamic value) {
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
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text('정말 모임장을 바꾸시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            await updateLeaderField();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("모임장 양도 완료"),
                              backgroundColor: Colors.blue,
                            ));
                          },
                          child: Text('모임장양도'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('취소'),
                        ),
                      ],
                    );
                  },
                ),
                child: Text("모임장양도"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("종료"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('정말 모임장을 바꾸시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await updateLeaderField();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("모임장 양도 완료"),
                  backgroundColor: Colors.blue,
                ));
                Navigator.of(context).pop();
              },
              child: Text('모임장양도'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
