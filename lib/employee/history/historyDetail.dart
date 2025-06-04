import 'package:flutter/material.dart';

class HistoryDetail extends StatefulWidget {
  const HistoryDetail({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ พื้นหลังสีขาว
      appBar: AppBar(
        title: Text('ประวัติการส่ง',style: TextStyle(fontSize: 16),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 📦 ข้อมูลร้านค้า
            Card(
              elevation: 2,
              color: Colors.white, // ✅ การ์ดสีขาว
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('00 พ.ค. 0000    12:00 น.',
                        style: TextStyle(color: Colors.grey[700], fontSize: 10)),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30), // ✅ วงกลม
                          child: Image.network(
                            widget.data['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('OPEN',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 12)),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('เวลาส่ง: 12:00 น.',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 12)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('ที่อยู่',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      'ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่ ที่อยู่',
                      style: TextStyle(height: 1.4),
                    ),
                    SizedBox(height: 8),
                    Text('เวลาทำการ',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('เปิด: 08:00 น.\nปิด: 17:00 น.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 🧾 รายการสินค้า
            Card(
              elevation: 2,
              color: Colors.white, // ✅ การ์ดสีขาว
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เก็บเงินแล้ว',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'วิธีชำระเงิน: เงินสด',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายการสินค้า', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('น้ำแข็งก้อน'),
                            Text('30 ถุง'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('น้ำแข็งบด'),
                            Text('10 ถุง'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ราคารวมทั้งหมด',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('100 บาท',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
