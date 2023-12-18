import 'package:flutter/material.dart';

class PointShopPage extends StatefulWidget {
  @override
  _PointShopPageState createState() => _PointShopPageState();
}

class _PointShopPageState extends State<PointShopPage> {
  List<PointShopItem> pointShopItems = [
    PointShopItem('아이템1', 'assets/point.png', 100),
    PointShopItem('아이템2', 'assets/point.png', 150),
    PointShopItem('아이템3', 'assets/point.png', 200),
  ]; // 샘플 포인트 상품 목록

  PointShopItem? selectedMeeting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(top: 20),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 18.0, right: 20.0),
          child: Row(
            children: [
              SizedBox(width: 8.0),
              const Text('포인트 상점'),
            ],
          ),
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // 1. '상품 선택' 열
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '상품 선택',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // 2. '포인트로 구매하고자 하는 상품을 선택하세요.' 텍스트
          ListTile(
            title: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Text(
                '포인트로 구매하고자 하는 상품을 선택하세요.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // 3. 상품 선택을 위한 리스트뷰
          _buildMeetingListView(),

          // 7. '구매하기' 버튼
          _buildRoundedButton(context),
        ],
      ),
    );
  }

  Widget _buildMeetingListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pointShopItems
            .map(
              (item) => Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.points} 포인트'),
                  leading: Image.asset(item.imagePath),
                  onTap: () {
                    setState(() {
                      selectedMeeting = item;
                    });
                  },
                  selected: selectedMeeting == item,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuantityListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [1, 2, 3, 4, 5]
            .map(
              (quantity) => RadioListTile(
                title: Text(quantity.toString()),
                value: quantity.toString(),
                groupValue: selectedMeeting,
                onChanged: (value) {
                  setState(() {
                    selectedMeeting = value as PointShopItem?;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 구매하기 버튼을 눌렀을 때의 로직을 추가하세요.
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFF6F61), // 코랄 핑크 색상
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(double.infinity, 40), // 가로로 꽉 차게 설정
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '구매하기',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PointShopItem {
  final String name;
  final String imagePath;
  final int points;

  PointShopItem(this.name, this.imagePath, this.points);
}
