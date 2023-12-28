import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Map<DateTime, List<Event>> _events = {};
  DateTime _selectedDate = DateTime.now();
  bool total = false;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _selectedDay = _focusedDay;

    _getEventsFromFirebaseFromToday();
  }

  Future<void> _getEventsFromFirebaseForTotal() async {
    _events = {};
    DateTime today = DateTime.now();

    try {
      // Firebase Firestore에서 이벤트 데이터 가져오기
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('totalMoimSchedule')
              .doc(widget.moimID)
              .collection("moimSchedule")
              .get();

      querySnapshot.docs.forEach((doc) {
        Timestamp predate = doc.data()['date'];
        DateTime date = DateTime.utc(predate.toDate().year,
            predate.toDate().month, predate.toDate().day);
        // 혹은 DateTime.utc(predate.toDate().year, predate.toDate().month, predate.toDate().day);

        var moimContent = (doc.data() as Map)['moimContent'];
        var moimLocation = (doc.data() as Map)['moimLocation'];
        var moimTitle = (doc.data() as Map)['moimTitle'];

        // 가져온 데이터를 TableCalendar에 맞게 변환하여 _events 맵에 추가
        _events[date] ??= [];

        _events[date]!.add(Event(moimTitle, moimContent, moimLocation));
      });

      setState(() {});
    } catch (e) {
      print('Firebase 데이터 가져오기 오류: $e');
    }
  }

  Future<void> _getEventsFromFirebaseFromToday() async {
    _events = {};
    DateTime today = DateTime.now();

    try {
      // Firebase Firestore에서 이벤트 데이터 가져오기
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('totalMoimSchedule')
              .doc(widget.moimID)
              .collection("moimSchedule")
              .where('date', isGreaterThanOrEqualTo: today)
              .get();

      querySnapshot.docs.forEach((doc) {
        Timestamp predate = doc.data()['date'];
        DateTime date = DateTime.utc(predate.toDate().year,
            predate.toDate().month, predate.toDate().day);
        // 혹은 DateTime.utc(predate.toDate().year, predate.toDate().month, predate.toDate().day);

        var moimContent = (doc.data() as Map)['moimContent'];
        var moimLocation = (doc.data() as Map)['moimLocation'];
        var moimTitle = (doc.data() as Map)['moimTitle'];

        // 가져온 데이터를 TableCalendar에 맞게 변환하여 _events 맵에 추가
        _events[date] ??= [];

        _events[date]!.add(Event(moimTitle, moimContent, moimLocation));
      });

      setState(() {});
    } catch (e) {
      print('Firebase 데이터 가져오기 오류: $e');
    }
  }

  // 이벤트를 추가하는 함수

  @override
  void dispose() {
    super.dispose();
    _events.clear();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedDate = selectedDay;
        total = false;
      });
    }
  }

  Widget _buildEventsLists() {
    // _events 맵에서 선택된 날짜에 해당하는 이벤트 가져오기
    List<Event> eventsForSelectedDate = _events[_selectedDate] ?? [];

    return ListView.builder(
      itemCount: eventsForSelectedDate.length,
      itemBuilder: (BuildContext context, int index) {
        Event event = eventsForSelectedDate[index];
        // 이벤트 세부 정보를 ListTile 또는 사용자 정의 위젯을 사용하여 표시
        return ListTile(
          title: Text(event.title),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title),
              Text(event.content),
              Divider(),
            ],
          ),
          // 필요한 경우 추가 정보 표시
        );
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildEventsList() {
    // Get all the dates in your events map and sort them
    List<DateTime> sortedDates = _events.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedDates.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime date = sortedDates[index];
        List<Event> eventsForDate = _events[date] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                DateFormat('yyyy-MM-dd').format(date), // Format date as needed
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: eventsForDate.length,
              itemBuilder: (BuildContext context, int index) {
                Event event = eventsForDate[index];
                // You can design the ListTile or widget to display event details
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.content),
                  // Add more details as needed
                );
              },
            ),
            Divider(), // Add a divider between dates if required
          ],
        );
      },
    );
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
              await showModalBottomSheet(
                context: context,
                isDismissible: true,
                builder: (context) => AddBottomSheet(
                    moimID: widget.moimID,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay),
              );
              setState(() {
                _getEventsFromFirebaseFromToday();
              });
            },
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: true,
            ),

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Checkbox(
                  value: total,
                  onChanged: (value) {
                    setState(() {
                      total = value!;
                      if (total) {
                        _getEventsFromFirebaseForTotal();
                      } else {
                        _getEventsFromFirebaseFromToday();
                      }
                    });
                  },
                ),
                Text("전체 정모 보기"),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF6F61),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      builder: (context) => AddBottomSheet(
                          moimID: widget.moimID,
                          focusedDay: _focusedDay,
                          selectedDay: _selectedDay),
                    );
                    setState(() {
                      _getEventsFromFirebaseFromToday();
                    });
                  },
                  child: Text("정모 생성"),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          total
              ? _buildEventsList()
              : Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: _buildEventsLists(),
                ),
        ],
      ),
    );
  }
}

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
  final String content;
  final String location;
  Event(this.title, this.content, this.location);
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
  final _locationController = TextEditingController();
  final _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String newDAY;
  String selectedTime = "";
  DateTime now = DateTime.now();
  late int _selectedValue;
  late DateTime selectedDate;
  TimeOfDay? picked;

  @override
  void initState() {
    super.initState();

    _selectedValue = 6;
    //picked = TimeOfDay.fromDateTime(DateTime(2000, 00, 00));

    if (widget.selectedDay == null) {
      newDAY = "";
      selectedDate = DateTime.now();
    } else {
      newDAY = widget.selectedDay.toString().substring(0, 10);
      selectedDate = widget.selectedDay!;
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
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    ))!;
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked!.format(context).toString();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              _buildTextField(_locationController, "정모 장소"),
              SizedBox(height: 20),
              _buildTextField(_titleController, "정모명"),
              SizedBox(height: 20),
              _buildTextField(_contentController, "정모 내용", maxLines: 5),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGrayButton(
                    () => _selectDate(context),
                    115.0,
                    50.0,
                    '날짜 선택\n${selectedDate != null ? DateFormat('yy-MM-dd').format(selectedDate!) : "날짜를 선택하세요"}',
                  ),
                  _buildGrayButton(
                    () => _selectTime(context),
                    115.0,
                    50.0,
                    '시간 선택\n${selectedTime ?? "시간을 선택하세요"}',
                  ),
                  _buildGrayButton(
                    () => _showNumberPickerModal(context),
                    115.0,
                    50.0,
                    '제한인원 : $_selectedValue',
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (picked != null) {
                          _addEventToFirebase(
                              selectedDate,
                              picked!,
                              _titleController.text,
                              _locationController.text,
                              _contentController.text);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("시간을 선택해 주세요"),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6F61),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '정모 만들기',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrayButton(
      Function() onPressed, double width, double height, String text) {
    return Container(
      width: width,
      height: height, // 세로 길이를 명시적으로 설정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, double width) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF6F61)),
        ),
      ),
    );
  }

  Future<void> _addEventToFirebase(DateTime selectedDate, TimeOfDay picked,
      String title, String location, String content) async {
    DateTime combinedDateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, picked.hour, picked.minute);
    Timestamp timestamp = Timestamp.fromDate(combinedDateTime);
    print('모임명 : $title');
    print('모임장소 : $location');
    print('타임스템프 : $timestamp');
    try {
      await _firestore
          .collection('totalMoimSchedule')
          .doc(widget.moimID)
          .collection("moimSchedule")
          .add({
        'date': timestamp,
        'moimLocation': location,
        'moimTitle': title,
        'moimContent': content,
      });

      // 이벤트를 Firebase에 추가한 후, 화면을 다시 빌드하여 새로운 이벤트를 표시
    } catch (e) {
      print('Firebase에 이벤트 추가 오류: $e');
    }
  }
}
