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
                _stepItem(1, 'ข้อมูลลูกค้า'),
                _stepDivider(),
                _stepItem(2, 'ข้อมูลบริการ'),
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
                _tabTwoContent(),
                _tabThreeContent(),
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
  
  Widget _tabTwoContent() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 12),

        Text(
          'กรุณาแสกนเอกสารของลูกค้าเพื่อเพิ่มข้อมูล',
          style: TextStyle(fontSize: 14, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // ใส่ฟังก์ชันสแกน
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'สแกนเอกสาร',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _tabThreeContent() {
  final days = ['วันจันทร์', 'วันอังคาร', 'วันพุธ', 'วันพฤหัสบดี', 'วันศุกร์', 'วันเสาร์', 'วันอาทิตย์'];

  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เลือกวันเวลาที่ต้องการส่ง', style: TextStyle(fontWeight: FontWeight.bold)),

        SizedBox(height: 8),
        ...days.map((day) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.indigo, size: 20),
                        SizedBox(width: 8),
                        Text(day),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  _timeField(),
                  SizedBox(width: 8),
                  _timeField(),
                ],
              ),
            )),

        SizedBox(height: 16),
        Text('เพิ่มรายการสินค้า', style: TextStyle(fontWeight: FontWeight.bold)),

        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              // เพิ่มสินค้า
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),

        SizedBox(height: 16),

        // สินค้า 1
        _productCard(
          imageUrl: 'https://i.imgur.com/w1urxVi.png',
          title: 'ถังน้ำแข็ง',
          options: ['เล็ก', 'กลาง', 'ใหญ่'],
          quantity: 3,
        ),

        SizedBox(height: 12),

        // สินค้า 2
        _productCard(
          imageUrl: 'https://i.imgur.com/ZK1dLkH.png',
          title: 'น้ำแข็งก้อน',
          options: [],
          quantity: 1,
        ),

        SizedBox(height: 24),

        // ปุ่มถัดไป
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('ถัดไป', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ),
  );
}

Widget _timeField() {
  return Expanded(
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'เวลา',
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Widget _productCard({
  required String imageUrl,
  required String title,
  required List<String> options,
  required int quantity,
}) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // รูปสินค้า
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (options.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: options
                          .map((option) => OutlinedButton(
                                onPressed: () {},
                                child: Text(option),
                              ))
                          .toList(),
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_circle_outline),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_outline),
            ),
          ],
        ),
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
