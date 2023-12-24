import 'package:cellpjt/appbar/creategroup.dart';
import 'package:cellpjt/appbar/groupsearch.dart';
import 'package:cellpjt/appbar/notification.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        if (kDebugMode) {
          print(loggedUser!.email);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  IconButton buildAppBarIconButton(IconData icon, Function onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed as void Function()?,
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 8.0), // 패딩 조절
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 17.0),
          child: const Text('셀모임 단체 채팅방'),
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
            // 검색 버튼 페이지 연결
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroupSearchPage()),
            );
          }),
          buildAppBarIconButton(Icons.add, () {
            // 글 작성 버튼 페이지 연결
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateGroupPage()),
            );
          }),
          buildAppBarIconButton(Icons.notifications_none, () {
            // 알림 페이지 연결
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
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Chattings(),
            ),
            NewChatSend(),
          ],
        ),
      ),
    );
  }
}

class Chattings extends StatelessWidget {
  const Chattings({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LinearProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return Bubbles(
                chatDocs[index]['text'],
                chatDocs[index]['userID'].toString() == user!.uid,
                chatDocs[index]['userName'],
                chatDocs[index]['userImage']);
          },
        );
      },
    );
  }
}

class Bubbles extends StatelessWidget {
  const Bubbles(this.message, this.isMe, this.userName, this.userImage,
      {Key? key})
      : super(key: key);

  final String message;
  final String userName;
  final bool isMe;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isMe)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
                child: ChatBubble(
                  clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(top: 20),
                  backGroundColor: Colors.blue,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
                child: ChatBubble(
                  clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
                  backGroundColor: const Color(0xffE7E7ED),
                  margin: const EdgeInsets.only(top: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
        Positioned(
          top: 0,
          right: isMe ? 5 : null,
          left: isMe ? null : 5,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        )
      ],
    );
  }
}

class NewChatSend extends StatefulWidget {
  const NewChatSend({super.key});

  @override
  State<NewChatSend> createState() => _NewChatSendState();
}

class _NewChatSendState extends State<NewChatSend> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user.uid,
      'userName': userData.data()!['userName'],
      'userImage': userData['picked_image']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: const InputDecoration(labelText: "메세지 전송"),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
