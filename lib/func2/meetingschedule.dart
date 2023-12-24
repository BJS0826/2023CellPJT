import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';

class MeetingSchedulePage extends StatefulWidget {
  final moimID;

  const MeetingSchedulePage({Key? key, required this.moimID});

  @override
  State<MeetingSchedulePage> createState() => _MeetingSchedulePageState();
}

class _MeetingSchedulePageState extends State<MeetingSchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dipose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    Map<DateTime, List<Event>> events = {};
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정모 일정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        shrinkWrap: true,
        children: [
          TableCalendar(
            locale: 'ko_kr', // 한국 달력 적용
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            eventLoader: _getEventsForDay,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onDayLongPressed: (selectedDay, focusedDay) async {
              return await showModalBottomSheet(
                context: context,
                isDismissible: true,
                builder: (context) => AddBottomSheet(
                    moimID: widget.moimID,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay),
              );
            },
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: true,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("전체모임보기")),
                ElevatedButton(onPressed: () {}, child: Text("전체정모보기")),
                ElevatedButton(
                    onPressed: () async {
                      return await showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        builder: (context) => AddBottomSheet(
                            moimID: widget.moimID,
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay),
                      );
                    },
                    child: Text("정모만들기")),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection("user").doc(user!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('데이터를 불러올 수 없습니다.'),
                  );
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.exists) {
                    var userData = snapshot.data!;

                    String email = userData["email"];
                    Map<String, dynamic> myMoimList = userData["myMoimList"];
                    String pickedImage = userData["picked_image"];
                    String userName = userData["userName"];

                    print(
                        "테스트 이메일 : $email / 모임리스트 : $myMoimList / 사진url : $pickedImage / 이름 : $userName");

                    List<Future<DocumentSnapshot<Map<String, dynamic>>>>
                        datasList = [];

                    for (String id in myMoimList.keys) {
                      Future<DocumentSnapshot<Map<String, dynamic>>> data =
                          _firestore.collection("Moim").doc(id).get();
                      datasList.add(data);
                    }

                    return FutureBuilder(
                        future: Future.wait(datasList),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshot.hasError) {
                              return Text('데이터를 불러올 수 없습니다.');
                            } else {
                              if (snapshot.hasData && snapshot.data != null) {
                                var MoImDatas = snapshot.data;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: MoImDatas!.length,
                                  itemBuilder: (context, index) {
                                    String moimTitle =
                                        MoImDatas[index]["moimTitle"];
                                    String moimImage =
                                        MoImDatas[index]["moimImage"];
                                    String moimTitles =
                                        MoImDatas[index]["moimTitle"];
                                    String moimID = MoImDatas[index].id;

                                    return GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Card(
                                          elevation: 2.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ListTile(
                                                leading: CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage:
                                                      NetworkImage(moimImage),
                                                ),
                                                title: Text(moimTitle),
                                                subtitle: Text(moimTitles,
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                              // ... 추가 정보 (모임 인원 등)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }
                          }
                        });
                  } else {
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

// ListView(
//   padding: EdgeInsets.all(16.0),
//   children: [
//     MeetingItem(
//       name: '23년 CM 리더 모임',
//       date: '12. 17(일)',
//       location: '베다니교회',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '두 번째 모임',
//       date: '12. 18(월)',
//       location: '두번째 장소',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '세 번째 모임',
//       date: '12. 19(화)',
//       location: '세번째 장소',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '세 번째 모임',
//       date: '12. 19(화)',
//       location: '세번째 장소',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '세 번째 모임',
//       date: '12. 19(화)',
//       location: '세번째 장소',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '세 번째 모임',
//       date: '12. 19(화)',
//       location: '세번째 장소',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '세 번째 모임',
//       date: '12. 19(화)',
//       location: '세번째 장소',
//     ),
//     Divider(color: Colors.grey), // 리스트 간의 회색 줄
//     MeetingItem(
//       name: '세 번째 모임',
//       date: '12. 19(화)',
//       location: '세번째 장소',
//     ),

//     // 다른 정모 항목 추가
//     // ...
//   ],
// ),

class MeetingItem extends StatelessWidget {
  final String name;
  final String date;
  final String location;

  const MeetingItem({
    required this.name,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '날짜: $date',
              ),
            ],
          ),
          Text(
            '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            location,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        // 정모 항목을 눌렀을 때의 동작 추가
      },
    );
  }
}

class Event {
  final String title;
  Event(this.title);
}

class AddBottomSheet extends StatefulWidget {
  final moimID;
  final DateTime? selectedDay;
  final DateTime? focusedDay;
  const AddBottomSheet(
      {super.key, this.selectedDay, this.focusedDay, required this.moimID});

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  final _titleController = TextEditingController();
  final _numberController = TextEditingController();
  final _locationController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String newDAY;
  late String selectedTime;
  DateTime now = DateTime.now();
  late int _selectedValue;

  @override
  void initState() {
    super.initState();

    selectedTime = DateTime.now().toString().substring(10, 19);
    _selectedValue = 6;

    if (widget.selectedDay == null) {
      newDAY = "";
    } else {
      newDAY = widget.selectedDay.toString().substring(0, 10);
    }
  }

  Widget _buildCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 40.0,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedValue = index;
        });
      },
      children: List.generate(100, (index) {
        return Center(
          child: Text(
            '$index',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDay ?? now,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != newDAY) {
      setState(() {
        newDAY = picked.toString().substring(0, 10);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked.format(context).toString();
      });
    }
  }

  void _showNumberPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 200.0,
          child: CupertinoPicker(
            itemExtent: 40.0,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedValue = index;
              });
            },
            children: List.generate(100, (index) {
              return Center(
                child: Text(
                  '$index',
                  style: TextStyle(fontSize: 20.0),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(color: Colors.blue[100]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text('날짜선택 ${newDAY}')),
              ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: Text('시간선택 $selectedTime')),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _showNumberPickerModal(context);
            },
            child: Text(
              '제한인원: $_selectedValue',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: "제한인원(숫자만 입력하세요)",
            ),
          ),
          TextField(
            controller: _locationController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "정모장소",
            ),
          ),
          TextField(
            controller: _titleController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "정모명",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("정모만들기")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("취소하기")),
            ],
          ),
        ],
      ),
    ));
  }
}
