import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ksice/constants.dart';
import 'package:ksice/employee/home/ListCar/listCarPage.dart';
import 'package:ksice/employee/home/customerPage.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double progressValue = 75.0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ภารกิจวันนี้',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerPage()));
              },
              style: TextButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('เพิ่มลูกค้า', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('00 พ.ค. 0000 12:00 น.', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            const SizedBox(height: 16),

            // กราฟสถานะ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('สถานะโดยรวมวันนี้', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildGaugeWithLabels(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // แท็บร้านค้า
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                tabs: [
                  _customTab(true, 'ร้านค้าที่ไปแล้ว', 2, Colors.blue),
                  _customTab(false, 'ร้านคาที่ยังไม่ไป', 0, Colors.green),
                ],
                onTap: (_) {
                  setState(() {});
                },
              ),
            ),

            const SizedBox(height: 16),

            // ข้อมูลร้านค้า
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      _buildShopItem('ร้านอาหารพลังใจ', 'ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่', '0909090900'),
                      _buildShopItem('ร้านอาหารพลังใจ', 'ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่', '55555555'),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text('ยังไม่มีข้อมูล'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: buttonColor),
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            final out = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              // return CreateItemPage();
              return ListCarPage();
            }));
          },
          tooltip: 'เพิ่มรายการ',
          child: Image.asset('assets/icons/tabler_truck-delivery_0.png')), //
    );
  }

  Widget _customTab(bool isActive, String title, int count, Color color) {
    final currentIndex = _tabController.index;
    final index = title.contains('ไปแล้ว') ? 0 : 1;
    final active = currentIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
              child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (active)
          Container(
            height: 2.5,
            width: 80,
            color: color,
          ),
      ],
    );
  }

  Widget _buildGaugeWithLabels() {
    return SizedBox(
      width: 360,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                ranges: [
                  _gaugeRange(0, 20, Colors.green),
                  _gaugeRange(20, 40, Colors.lightGreen),
                  _gaugeRange(40, 60, Colors.yellow),
                  _gaugeRange(60, 80, Colors.orange),
                  _gaugeRange(80, 100, Colors.red),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: progressValue,
                    enableAnimation: true,
                    animationDuration: 800,
                    needleLength: 0.7,
                    lengthUnit: GaugeSizeUnit.factor,
                    needleStartWidth: 2, // ✅ ปรับให้หนาขึ้น
                    needleEndWidth: 4,
                    needleColor: Colors.black,
                    knobStyle: const KnobStyle(
                      color: Colors.black,
                      borderColor: Colors.black,
                      borderWidth: 1.5,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                    ),
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
          ..._buildOverlayLabels(), // ✅ ตัวเลขบนเส้น
        ],
      ),
    );
  }

// 🔧 เพิ่มแยก Range สีพร้อม border
  GaugeRange _gaugeRange(double start, double end, Color color) {
    return GaugeRange(
      startValue: start,
      endValue: end,
      color: color,
      sizeUnit: GaugeSizeUnit.factor,
      startWidth: 0.45,
      endWidth: 0.45,
    );
  }

  List<Widget> _buildOverlayLabels() {
    List<int> values = [0, 20, 40, 60, 80, 100];
    double radius = 95; // ✅ ขยับให้อยู่บนโค้ง
    double centerX = 180;
    double centerY = 100;

    return values.map((v) {
      double angle = 180 - (v / 100 * 180);
      double x = radius * cos(angle * pi / 180);
      double y = radius * sin(angle * pi / 180);

      return Positioned(
        left: centerX + x - 10,
        top: centerY - y - 9,
        child: Text(
          '$v',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  Widget _buildShopItem(String name, String address, String phone) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border(
        //   left: BorderSide(color: Colors.blue, width: 3),
        // ),
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
              Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold))),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
