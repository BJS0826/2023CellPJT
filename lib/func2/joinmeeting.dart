import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinMeetingPage extends StatelessWidget {
  final moimID;

  JoinMeetingPage({super.key, required this.moimID});

  final TextEditingController greetingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모임 가입',
      home: Scaffold(
        appBar: AppBar(
          title: Text('모임 가입'),
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
                  '가입인사',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              TextField(
                controller: greetingController,
                maxLines: 3, // 가입인사를 위해 여러 줄 입력 가능하도록 설정
                decoration: InputDecoration(
                  hintText: '가입인사를 작성하세요.',
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  contentPadding: EdgeInsets.all(16.0),
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
                        onPressed: () async {
                          if (greetingController.text.isNotEmpty) {
                            final user = FirebaseAuth.instance.currentUser;

                            final userData = await FirebaseFirestore.instance
                                .collection('user')
                                .doc(user!.uid)
                                .get();
                            await FirebaseFirestore.instance
                                .collection('totalChat')
                                .doc(moimID)
                                .collection('chat')
                                .add({
                              'text': greetingController.text,
                              'time': Timestamp.now(),
                              'userID': user.uid,
                              'userName': userData.data()!['userName'],
                              'userImage': userData['picked_image']
                            });
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(user.uid)
                                .update({
                              'myMoimList.${moimID}': DateTime.now(),
                            });
                            await FirebaseFirestore.instance
                                .collection('Moim')
                                .doc(moimID)
                                .update({
                              'moimMembers.${user.uid}':
                                  userData.data()!['userName'],
                            });

                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("모임가입 실패"),
                              backgroundColor: Colors.blue,
                            ));
                          }
                        },
                        child: Text('모임 가입'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
