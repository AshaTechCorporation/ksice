import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ksice/employee/home/selectedMap.dart';
import 'package:ksice/employee/home/services/homeService.dart';
import 'package:ksice/employee/home/widgets/FormInputField.dart';
import 'package:ksice/upload/uploadService.dart';
import 'package:ksice/utils/ApiExeption.dart';
import 'package:ksice/widgets/camera.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';

class CustomerPage extends StatefulWidget {
  CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage>
    with TickerProviderStateMixin {
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
  final Map<String, String> thaiToKey = {
    'วันจันทร์': 'mon',
    'วันอังคาร': 'tue',
    'วันพุธ': 'wed',
    'วันพฤหัสบดี': 'thu',
    'วันศุกร์': 'fri',
    'วันเสาร์': 'sat',
    'วันอาทิตย์': 'sun',
  };
  List<File> selectedImages = [];
  int iceTankQty = 3;
  int iceCubeQty = 1;
  List<File> shopImages = [];
  LatLng? result;
  TextEditingController nameShopController = TextEditingController();
  TextEditingController detailShopController = TextEditingController();
  TextEditingController openDateController = TextEditingController();
  TextEditingController openTimeController = TextEditingController();
  TextEditingController closeDateController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();

  bool scanned = false;

  TextEditingController card_fname = TextEditingController();
  TextEditingController card_lname = TextEditingController();
  TextEditingController card_birth_date = TextEditingController();
  TextEditingController card_address = TextEditingController();
  TextEditingController card_district = TextEditingController();
  TextEditingController card_sub_district = TextEditingController();
  TextEditingController card_postal_code = TextEditingController();
  TextEditingController card_gender = TextEditingController();
  TextEditingController card_idcard = TextEditingController();
  TextEditingController card_province = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final Map<String, TextEditingController> startControllers = {};
  final Map<String, TextEditingController> endControllers = {};

  String? imageAPI;
  List<String>? listImageAPI;

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatToTime(String input) {
    // แยกชั่วโมงและนาทีจากรูปแบบ 12 ชั่วโมง เช่น "1:41 AM"
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$', caseSensitive: false)
        .firstMatch(input.replaceAll(RegExp(r'[\u202F\u00A0\s]+'), ' ').trim());

    if (match == null) {
      throw FormatException('Invalid time format: $input');
    }

    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    String period = match.group(3)!.toUpperCase();

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return '${_twoDigits(hour)}:${_twoDigits(minute)}:00';
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
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
    return GestureDetector(
      onTap: () {
        // focusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('เพิ่มข้อมูลลูกค้า'),
          backgroundColor: Colors.white,
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
                  _stepDivider(0),
                  _stepItem(1, 'ข้อมูลลูกค้า'),
                  _stepDivider(1),
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
      ),
    );
  }

  Widget _stepItem(int index, String label) {
    bool active = _tabController.index >= index;
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

  Widget _stepDivider(int index) {
    bool active = index <= _tabController.index;
    return Container(
      width: 24,
      height: 2,
      color: active ? Colors.indigo : Colors.grey.shade300,
    );
  }

  Widget _tabOneContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('ชื่อร้านค้า'),
          _textField('ชื่อร้านค้า', nameShopController),
          SizedBox(height: 16),

          _label('รายละเอียดร้านค้า'),
          _textField('รายละเอียดร้านค้า', detailShopController, maxLines: 3),
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
              Expanded(
                  child: _imageButton('เพิ่มรูปภาพ', Icons.add_a_photo,
                      fromCamera: false)),
              SizedBox(width: 8),
              Expanded(
                  child: _imageButton('ถ่ายภาพ', Icons.camera_alt_outlined,
                      fromCamera: true)),
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
                          child: Image.file(file,
                              width: 64, height: 64, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => shopImages.removeAt(index)),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label('แผนที่ร้านค้า'),
              SizedBox(
                width: 150,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectedMapPage(),
                      ),
                    );

                    if (result != null) {
                      print(
                          'เลือกแล้ว: lat=${result!.latitude}, lng=${result!.longitude}');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          6), // ✅ ลดความมนจาก 12 → 6 หรือ 4
                    ),
                  ),
                  child: const Text('เลือกแผนที่'),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          //_textField('รายละเอียดที่ตั้งร้านค้า', maxLines: 2),
          SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              onPressed: () async {
                goToStep(1);
              },
              child: Text('ถัดไป',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!scanned) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/Idcard.png',
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
                onPressed: () async {
                  final out = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return IDCardCameraPage();
                  }));
                  if (out != null) {
                    try {
                      LoadingDialog.open(context);
                      final ocr =
                          await UoloadService.ocrIdCard(file: File(out.path));
                      final image = await UoloadService.addImage(
                          file: File(out.path), path: 'images/asset/');

                      setState(() {
                        imageAPI = image;
                        card_fname.text = ocr['th_fname'];
                        card_lname.text = ocr['th_lname'];
                        card_address.text =
                            '${ocr['home_address']} ${ocr['sub_district']} ${ocr['district']} ${ocr['province']}';
                        card_birth_date.text = ocr['birth_date'];
                        card_district.text = ocr['district'];
                        card_sub_district.text = ocr['sub_district'];
                        card_postal_code.text = ocr['postal_code'];
                        card_gender.text = '';
                        card_idcard.text = ocr['id_card'];
                        card_province.text = ocr['province'];
                        scanned = true;
                      });
                      LoadingDialog.close(context);
                    } on ClientException catch (e) {
                      if (!mounted) return;
                      LoadingDialog.close(context);
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          description: '$e',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    } on ApiException catch (e) {
                      if (!mounted) return;
                      LoadingDialog.close(context);
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          description: '$e',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    } on Exception catch (e) {
                      if (!mounted) return;
                      LoadingDialog.close(context);
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          description: '$e',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      LoadingDialog.close(context);
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          description: '$e',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    }
                  }
                  // setState(() {
                  //   scanned = true; // ✅ ฟิกว่าสแกนสำเร็จ
                  // });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'สแกนเอกสาร',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child:
                        FormInputField(hint: 'ชื่อ', controller: card_fname)),
                SizedBox(width: 8),
                Expanded(
                    child: FormInputField(
                        hint: 'นามสกุล', controller: card_lname)),
              ],
            ),
            SizedBox(height: 16),
            FormInputField(hint: 'ที่อยู่', controller: card_address),
            SizedBox(height: 16),
            FormInputField(
              hint: 'เบอร์โทรศัพท์',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // ทำอะไรเมื่อกด "ถัดไป"
                  print('ชื่อ: ${card_fname.text}');
                  goToStep(2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('ถัดไป',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]
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
          Text('เลือกวันเวลาที่ต้องการส่ง',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...days.map((day) {
            startControllers.putIfAbsent(day, () => TextEditingController());
            endControllers.putIfAbsent(day, () => TextEditingController());

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
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
                    child: Text('-',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700)),
                  ),
                  _timePickerField(endControllers[day]!),
                ],
              ),
            );
          }),
          SizedBox(height: 24),
          Text('เพิ่มรายการสินค้า',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.indigo),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                          child: Image.file(file,
                              width: 100, height: 80, fit: BoxFit.cover),
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
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
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
            onRemove: () => setState(
                () => iceTankQty = (iceTankQty > 0) ? iceTankQty - 1 : 0),
          ),
          Divider(),
          _productCard(
            title: 'น้ำแข็งก้อน',
            options: [],
            quantity: iceCubeQty,
            onAdd: () => setState(() => iceCubeQty++),
            onRemove: () => setState(
                () => iceCubeQty = (iceCubeQty > 0) ? iceCubeQty - 1 : 0),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  LoadingDialog.open(context);
                  selectedImages.clear();
                  if (selectedImages.isNotEmpty) {
                    for (var i = 0; i < selectedImages.length; i++) {
                      final image = await UoloadService.addImage(
                          file: File(selectedImages[i].path),
                          path: 'images/asset/');
                      selectedImages.add(image);
                    }
                  }

                  final Map<String, int> workDays = {
                    for (var entry in daySelected.entries)
                      thaiToKey[entry.key]!: entry.value ? 1 : 0
                  };
                  Map<String, String> workTimes = {};
                  for (final day in thaiToKey.keys) {
                    final key = thaiToKey[day]!;
                    final isActive = daySelected[day] ?? false;

                    final start = startControllers[day]?.text.trim() ?? '';
                    final end = endControllers[day]?.text.trim() ?? '';

                    workTimes['${key}_start_time'] =
                        isActive && start.isNotEmpty
                            ? _formatToTime(start)
                            : '';
                    workTimes['${key}_end_time'] =
                        isActive && end.isNotEmpty ? _formatToTime(end) : '';
                  }
                  inspect(workDays);
                  inspect(workTimes);
                  final addCustomer = await HomeService.customerCreate(
                    name: nameShopController.text,
                    detail: detailShopController.text,
                    phone: phoneController.text,
                    date_work: openDateController.text,
                    time_time: openTimeController.text,
                    lat: result!.latitude.toString(), // แทนที่ด้วยค่าจริง
                    lon: result!.longitude.toString(), // แทนที่ด้วยค่าจริง
                    card_fname: card_fname.text,
                    card_lname: card_lname.text,
                    card_birth_date: card_birth_date.text, // แทนที่ด้วยค่าจริง
                    card_address: card_address.text,
                    card_district: card_district.text,
                    card_sub_district: card_sub_district.text,
                    card_postal_code: card_postal_code.text,
                    card_gender: card_gender.text,
                    card_idcard: card_idcard.text, // แทนที่ด้วยค่าจริง
                    card_image: imageAPI ?? '', // แทนที่ด้วยค่าจริง
                    card_province: 'กรุงเทพมหานคร', // แทนที่ด้วยค่าจริง
                    member_shop_images: listImageAPI ?? [],
                    work_days: workDays,
                    work_times: workTimes,
                  );
                  LoadingDialog.close(context);
                  if (!mounted) return;
                  if (addCustomer['status'] == true) {
                    Navigator.pop(context);
                  }
                } on Exception catch (e) {
                  if (!mounted) return;
                  LoadingDialog.close(context);
                  showDialog(
                    context: context,
                    builder: (context) => ErrorDialog(
                      description: '$e',
                      pressYes: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('ถัดไป',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timePickerField(TextEditingController controller) {
    return GestureDetector(
      onTap: () => _selectTime(controller),
      child: AbsorbPointer(
        child: Container(
          width: 80,
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            controller.text.isEmpty ? 'เลือกเวลา' : controller.text,
            style: TextStyle(fontSize: 13, color: Colors.black),
          ),
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
            IconButton(
                onPressed: () {}, icon: Icon(Icons.delete, color: Colors.grey)),
          ],
        ),
        if (options.isNotEmpty)
          Row(
            children: options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

  Widget _textField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
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
