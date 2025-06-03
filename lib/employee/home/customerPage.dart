import 'package:flutter/material.dart';
import 'package:ksice/employee/home/selectLocationPage.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลลูกค้า'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 ขั้นตอน
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Colors.blue, child: Text('1', style: TextStyle(color: Colors.white, fontSize: 12))),
                SizedBox(width: 8),
                Text('ข้อมูลร้าน'),
                SizedBox(width: 16),
                CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Text('2', style: TextStyle(color: Colors.black87, fontSize: 12))),
                SizedBox(width: 8),
                Text(' - '),
                SizedBox(width: 16),
                CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Text('3', style: TextStyle(color: Colors.black87, fontSize: 12))),
              ],
            ),
            Divider(height: 32),

            // 🔹 ชื่อร้านค้า
            TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // 🔹 รายละเอียดร้านค้า
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'รายละเอียดร้านค้า',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // 🔹 วันเวลา
            Text('เลือกวันเวลาที่ร้านเปิด'),
            SizedBox(height: 8),
            Row(
              children: [
                _dateTimeField('วันที่'),
                SizedBox(width: 8),
                _dateTimeField('เวลา'),
                SizedBox(width: 8),
                _dateTimeField('วันที่'),
                SizedBox(width: 8),
                _dateTimeField('เวลา'),
              ],
            ),
            SizedBox(height: 24),

            // 🔹 ภาพร้านค้า
            Text('ภาพร้านค้า'),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _imageButton('เพิ่มรูปภาพ', Icons.add_a_photo)),
                SizedBox(width: 8),
                Expanded(child: _imageButton('ถ่ายภาพ', Icons.camera_alt_outlined)),
              ],
            ),
            SizedBox(height: 12),

            // 🔹 ภาพแสดง
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, color: Colors.grey),
                  ),
                );
              }),
            ),
            SizedBox(height: 24),

            // 🔹 แผนที่ร้านค้า
            Text('แผนที่ร้านค้า'),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                child: Text('เลือกแผนที่'),
              ),
            ),

            SizedBox(height: 16),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'รายละเอียดที่ตั้งร้านหรือรายละเอียดที่ตั้งร้านค้า',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // 🔵 ปุ่มถัดไป
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectLocationPage()));
                },
                child: Text('ถัดไป', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _imageButton(String label, IconData icon) {
  return OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(icon, color: Colors.black54),
    label: Text(label, style: TextStyle(color: Colors.black87)),
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 14),
      side: BorderSide(color: Colors.grey),
    ),
  );
}

Widget _dateTimeField(String hint) {
  return Expanded(
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    ),
  );
}
