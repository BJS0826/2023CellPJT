import 'package:flutter/material.dart';

class GroupSearchPage extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  GroupSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모임 검색',
      home: Scaffold(
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
      ),
    );
  }
}
