import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void goToStep(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลลูกค้า'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔵 Step bar
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _stepItem(0, 'ข้อมูลร้าน'),
                _stepDivider(),
                _stepItem(1, ''),
                _stepDivider(),
                _stepItem(2, ''),
              ],
            ),
          ),

          // 🔵 Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _tabOneContent(),
                _noDataContent(),
                _noDataContent(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _stepItem(int index, String label) {
    bool active = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => goToStep(index),
        child: Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: active ? Colors.indigo : Colors.grey.shade300,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: active ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: active ? Colors.indigo : Colors.grey,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stepDivider() {
    return Container(
      width: 24,
      height: 2,
      color: Colors.grey.shade300,
    );
  }

  Widget _tabOneContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('ชื่อร้านค้า'),
          _textField('ชื่อร้านค้า'),
          SizedBox(height: 16),

          _label('รายละเอียดร้านค้า'),
          _textField('รายละเอียดร้านค้า', maxLines: 3),
          SizedBox(height: 16),

          _label('เลือกวันเวลาที่ร้านเปิด'),
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

          _label('ภาพร้านค้า'),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _imageButton('เพิ่มรูปภาพ', Icons.add_a_photo)),
              SizedBox(width: 8),
              Expanded(child: _imageButton('ถ่ายภาพ', Icons.camera_alt_outlined)),
            ],
          ),
          SizedBox(height: 12),

          // preview image placeholders
          Row(
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

          _label('แผนที่ร้านค้า'),
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
          _textField('รายละเอียดที่ตั้งร้านค้า', maxLines: 2),
          SizedBox(height: 24),

          // ปุ่มถัดไป
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              onPressed: () => goToStep(1),
              child: Text('ถัดไป', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _noDataContent() {
    return Center(
      child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.grey.shade600)),
    );
  }

  Widget _label(String text) {
    return Text(text, style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _textField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
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
}
