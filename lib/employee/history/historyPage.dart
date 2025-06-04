import 'package:flutter/material.dart';
import 'package:ksice/employee/history/historyDetail.dart';
import 'package:ksice/employee/history/widgets/DeliveryItem.dart';
import 'package:ksice/employee/history/widgets/SectionHeader.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> todayItems = List.generate(3, (_) => sampleData());
  final List<Map<String, dynamic>> yesterdayItems = List.generate(4, (_) => sampleData());

  static Map<String, dynamic> sampleData() => {
        'time': '00 พ.ค. 0000   12:00 น.',
        'image': 'https://img.freepik.com/free-photo/top-view-thai-food-with-copy-space_23-2148747555.jpg',
        'title': 'ร้านอาหารพลังใจ',
        'address': 'ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่',
        'status': 'เก็บบันทึกแล้ว',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ พื้นหลังขาว
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text('ประวัติการส่ง', style: TextStyle(color: Colors.black, fontSize: 16)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SectionHeader(title: 'วันนี้'),
          ...todayItems.map((item) => DeliveryItem(
                data: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HistoryDetail(data: item)),
                  );
                },
              )),
          SizedBox(height: 16),
          SectionHeader(title: 'เมื่อวานนี้'),
          ...yesterdayItems.map((item) => DeliveryItem(
                data: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HistoryDetail(data: item)),
                  );
                },
              )),
        ],
      ),
    );
  }
}
