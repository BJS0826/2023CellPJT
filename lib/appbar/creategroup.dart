import 'package:flutter/material.dart';

import 'package:numberpicker/numberpicker.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  String selectedInterest = '독서'; // 기본 관심사
  String selectedLocation = '서울'; // 기본 지역
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController groupMembersController = TextEditingController();
  int _moimLimit = 10;

  void _showPickerModal(BuildContext context) {
    int selectedNumber = _moimLimit;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 화면 아래에서 올라오도록 설정
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              Container(
                height: 200.0,
                child: Center(
                  child: NumberPicker(
                    textStyle: TextStyle(fontSize: 12),
                    minValue: 10,
                    maxValue: 50,
                    step: 10,
                    haptics: true,
                    value: selectedNumber,
                    onChanged: (value) {
                      setState(() {
                        selectedNumber = value;
                        _moimLimit = selectedNumber;
                      });
                    },
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("닫기"))
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모임 생성'),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '모임명',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      hintText: '모임명을 입력하세요.',
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '모임 소개',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextField(
                      maxLines: null,
                      controller: groupDescriptionController,
                      decoration: InputDecoration(
                        hintText: '모임 소개를 입력하세요.',
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '관심사',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedInterest,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedInterest = newValue!;
                      });
                    },
                    items: <String>['독서', '경제', '예술', '음악', '운동', '직무', '자유']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '지역',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedLocation,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                      });
                    },
                    items: <String>['서울', '경기 남부', '경기 북부', '인천']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '모임 인원',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  // TextField(
                  //   controller: groupMembersController,
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //     hintText: '모임 인원을 입력하세요.',
                  //     filled: true,
                  //     fillColor: Color(0xFFFFFFFF),
                  //     contentPadding: EdgeInsets.symmetric(
                  //         vertical: 10.0, horizontal: 16.0),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //   ),
                  // ),
                  TextButton(
                      onPressed: () {
                        _showPickerModal(context);
                      },
                      child: Text('$_moimLimit')),
                ],
              ),
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
                          // 모임 생성 버튼
                        },
                        child: Text('모임 생성'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
