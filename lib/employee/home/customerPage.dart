import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, bool> daySelected = {
  'วันจันทร์': true,
  'วันอังคาร': true,
  'วันพุธ': true,
  'วันพฤหัสบดี': true,
  'วันศุกร์': true,
  'วันเสาร์': true,
  'วันอาทิตย์': true,
};
List<File> selectedImages = [];
int iceTankQty = 3;
int iceCubeQty = 1;
List<File> shopImages = [];

TextEditingController openDateController = TextEditingController();
TextEditingController openTimeController = TextEditingController();
TextEditingController closeDateController = TextEditingController();
TextEditingController closeTimeController = TextEditingController();

final Map<String, TextEditingController> startControllers = {};
final Map<String, TextEditingController> endControllers = {};


Future<void> _selectTime(TextEditingController controller) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    controller.text = picked.format(context);
  }
}

Future<void> _pickImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked != null) {
    setState(() {
      selectedImages.add(File(picked.path));
    });
  }
}

Future<void> _pickShopImage({required bool fromCamera}) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: fromCamera ? ImageSource.camera : ImageSource.gallery,
  );

  if (picked != null) {
    setState(() => shopImages.add(File(picked.path)));
  }
}


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
            _datePickerField(openDateController, 'วันที่'),
            SizedBox(width: 8),
            _timePickerField(openTimeController),
            SizedBox(width: 8),
            _datePickerField(closeDateController, 'วันที่'),
            SizedBox(width: 8),
            _timePickerField(closeTimeController),
          ],
        ),
        SizedBox(height: 24),

        _label('ภาพร้านค้า'),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _imageButton('เพิ่มรูปภาพ', Icons.add_a_photo, fromCamera: false)),
            SizedBox(width: 8),
            Expanded(child: _imageButton('ถ่ายภาพ', Icons.camera_alt_outlined, fromCamera: true)),
          ],
        ),
        SizedBox(height: 12),

        // preview รูปภาพที่เลือก
        if (shopImages.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: shopImages.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, width: 64, height: 64, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => shopImages.removeAt(index)),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
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

Widget _datePickerField(TextEditingController controller, String hint) {
  return Expanded(
    child: GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            controller.text = '${picked.day}/${picked.month}/${picked.year}';
          });
        }
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft,
        child: Text(controller.text.isEmpty ? hint : controller.text),
      ),
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
  final days = daySelected.keys.toList();

  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เลือกวันเวลาที่ต้องการส่ง', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        ...days.map((day) {
          startControllers.putIfAbsent(day, () => TextEditingController());
          endControllers.putIfAbsent(day, () => TextEditingController());

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: Text(day)),
                Switch(
                  value: daySelected[day] ?? false,
                  onChanged: (val) {
                    setState(() {
                      daySelected[day] = val;
                    });
                  },
                  activeColor: Colors.indigo,
                ),
                SizedBox(width: 8),
                _timePickerField(startControllers[day]!),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text('-', style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                ),
                _timePickerField(endControllers[day]!),
              ],
            ),
          );
        }),

        SizedBox(height: 24),
        Text('เพิ่มรายการสินค้า', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.indigo),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: Icon(Icons.add, color: Colors.indigo),
          ),
        ),

        SizedBox(height: 16),

        if (selectedImages.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedImages.asMap().entries.map((entry) {
                int index = entry.key;
                File file = entry.value;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, width: 100, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          ),

        SizedBox(height: 16),
        _productCard(
          title: 'ถังน้ำแข็ง',
          options: ['เล็ก', 'กลาง', 'ใหญ่'],
          quantity: iceTankQty,
          onAdd: () => setState(() => iceTankQty++),
          onRemove: () => setState(() => iceTankQty = (iceTankQty > 0) ? iceTankQty - 1 : 0),
        ),

        Divider(),

        _productCard(
          title: 'น้ำแข็งก้อน',
          options: [],
          quantity: iceCubeQty,
          onAdd: () => setState(() => iceCubeQty++),
          onRemove: () => setState(() => iceCubeQty = (iceCubeQty > 0) ? iceCubeQty - 1 : 0),
        ),

        SizedBox(height: 24),
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


Widget _timePickerField(TextEditingController controller) {
  return GestureDetector(
    onTap: () async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        final now = DateTime.now();
        final selected = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        final timeString = TimeOfDay.fromDateTime(selected).format(context);
        setState(() {
          controller.text = timeString;
        });
      }
    },
    child: Container(
      width: 90,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        controller.text.isEmpty ? 'เวลา' : controller.text,
        style: TextStyle(color: Colors.grey.shade800),
      ),
    ),
  );
}


Widget _productCard({
  required String title,
  required List<String> options,
  required int quantity,
  required VoidCallback onAdd,
  required VoidCallback onRemove,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Colors.grey)),
        ],
      ),
      if (options.isNotEmpty)
        Row(
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(option),
              ),
            );
          }).toList(),
        ),
      SizedBox(height: 8),
      Row(
        children: [
          Text('จำนวน'),
          SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.remove_circle_outline, color: Colors.indigo),
          ),
          Text('$quantity', style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: onAdd,
            icon: Icon(Icons.add_circle_outline, color: Colors.indigo),
          ),
        ],
      ),
    ],
  );
}

Widget _timeField() {
  return Expanded(
    child: Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerLeft,
      child: Text('เวลา', style: TextStyle(color: Colors.grey.shade600)),
    ),
  );
}

Widget _productImage(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(url, width: 100, height: 80, fit: BoxFit.cover),
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

  Widget _imageButton(String label, IconData icon, {required bool fromCamera}) {
  return OutlinedButton.icon(
    onPressed: () => _pickShopImage(fromCamera: fromCamera),
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
