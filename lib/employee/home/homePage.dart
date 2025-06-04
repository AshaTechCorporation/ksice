import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ksice/employee/home/customerPage.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double progressValue = 75.0;

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ภารกิจวันนี้',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerPage()));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'เพิ่มลูกค้า',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '00 พ.ค. 0000 12:00 น.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 16),

            // 📊 กราฟ speed meter
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('สถานะโดยรวมวันนี้'),
                  SizedBox(height: 16),
                  _buildGaugeWithLabels(),
                ],
              ),
            ),

            SizedBox(height: 24),

            // 🟣 สถานะร้านค้า
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatus('ร้านค้าที่ไปแล้ว', 1, Colors.blue),
                _buildStatus('ร้านคาที่ยังไม่ไป', 1, Colors.green),
              ],
            ),

            SizedBox(height: 16),

            // 🧾 รายการร้านค้า
            _buildShopItem('ร้านอาหารพลังใจ', 'ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่', '0909090900'),
            _buildShopItem('ร้านอาหารพลังใจ', 'ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่', '0909090900'),
          ],
        ),
      ),
    );
  }

  Widget _buildGaugeWithLabels() {
    return SizedBox(
      width: 360,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(height: 20,),
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                startAngle: 180,
                endAngle: 360,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.85,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 20, color: Colors.green, startWidth: 0.45, endWidth: 0.45, sizeUnit: GaugeSizeUnit.factor),
                  GaugeRange(startValue: 20, endValue: 40, color: Colors.lightGreen, startWidth: 0.45, endWidth: 0.45, sizeUnit: GaugeSizeUnit.factor),
                  GaugeRange(startValue: 40, endValue: 60, color: Colors.yellow, startWidth: 0.45, endWidth: 0.45, sizeUnit: GaugeSizeUnit.factor),
                  GaugeRange(startValue: 60, endValue: 80, color: Colors.orange, startWidth: 0.45, endWidth: 0.45, sizeUnit: GaugeSizeUnit.factor),
                  GaugeRange(startValue: 80, endValue: 100, color: Colors.red, startWidth: 0.45, endWidth: 0.45, sizeUnit: GaugeSizeUnit.factor),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: progressValue,
                    enableAnimation: true,
                    animationDuration: 800,
                    needleLength: 0.7,
                    lengthUnit: GaugeSizeUnit.factor,
                    needleStartWidth: 1,
                    needleEndWidth: 5,
                    needleColor: Colors.black,
                    knobStyle: const KnobStyle(color: Colors.black),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    angle: 90,
                    positionFactor: 0.3,
                    widget: Text(
                      '${progressValue.toInt()}%',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                
              ),
            ],
          ),
          ..._buildOverlayLabels(),
        ],
      ),
    );
  }

  List<Widget> _buildOverlayLabels() {
  List<int> values = [0, 20, 40, 60, 80, 100];
  double radius = 85; // ปรับให้พอดีกับวง
  double centerX = 180; // กลางของ SizedBox width: 360
  double centerY = 100; // กลางของ SizedBox height: 200

  return values.map((v) {
    double angle = 180 - (v / 100 * 180); // วางตามครึ่งวงกลมด้านบน
    double x = radius * cos(angle * pi / 180);
    double y = radius * sin(angle * pi / 180);

    return Positioned(
      left: centerX + x - 10, // -10 เพื่อให้เลขอยู่ตรงกลาง
      top: centerY - y - 10,   // -8 เพื่อไม่ให้โดนตัดขอบล่าง
      child: Text(
        '$v',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }).toList();
}



  // List<Widget> _buildOverlayLabels() {
  //   List<int> values = [0, 20, 40, 60, 80, 100];
  //   return values.map((v) {
  //     double angle = 182 - (v / 100 * 180);
  //     double radius = 121;
  //     double x = radius * cos(angle * pi / 180);
  //     double y = radius * sin(angle * pi / 185);

  //     return Positioned(
  //       left: 170 + x,
  //       top: 110 - y,
  //       child: Text(
  //         '$v',
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //       ),
  //     );
  //   }).toList();
  // }

  Widget _buildStatus(String title, int count, Color color) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        SizedBox(width: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
          child: Text(
            '$count',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildShopItem(String name, String address, String phone) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.blue, width: 3),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text(phone),
            ],
          ),
          SizedBox(height: 4),
          Text(address, style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          Row(
            children: [
              _buildTag('OPEN', Colors.green),
              SizedBox(width: 6),
              _buildTag('เวลาทำการ: 08.00 น. - 17.00 น.', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
