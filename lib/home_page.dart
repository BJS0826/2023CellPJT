import 'package:cellpjt/bottomnav/grouplist.dart';
import 'package:cellpjt/bottomnav/mainfeed.dart';
import 'package:cellpjt/bottomnav/chatting.dart';
import 'package:cellpjt/bottomnav/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () => setState(() {
                _selectedIndex = 0;
              }),
              icon: const Icon(Icons.home),
              color: Colors.black54,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () => setState(() {
                _selectedIndex = 1;
              }),
              icon: const Icon(Icons.group),
              color: Colors.black54,
            ),
            label: '모임',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () => setState(() {
                _selectedIndex = 2;
              }),
              icon: const Icon(Icons.chat),
              color: Colors.black54,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () => setState(() {
                _selectedIndex = 3;
              }),
              icon: const Icon(Icons.person),
              color: Colors.black54,
            ),
            label: '프로필',
          ),
        ],
      ),
      body: _widgetList.elementAt(_selectedIndex),
    );
  }
}

List<Widget> _widgetList = <Widget>[
  MainFeedPage(),
  GroupListPage(),
  ChattingPage(),
  ProfilePage(),
];
