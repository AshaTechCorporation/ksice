import 'package:flutter/material.dart';
import 'package:ksice/employee/map/successPage.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';

class PaymentOrderPage extends StatefulWidget {
  const PaymentOrderPage({super.key, required this.shop, required this.itemsSelect});
  final Map<String, dynamic> shop;
  final List<Map<String, dynamic>> itemsSelect;

  @override
  State<PaymentOrderPage> createState() => _PaymentOrderPageState();
}

class _PaymentOrderPageState extends State<PaymentOrderPage> {
  int selectedOcjective = 0;
  List<String> checkOcjective = [
    'เงินสด',
    'โอนเงิน',
  ];
  int? sumPrice;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    sumPrice = widget.itemsSelect.fold(0, (sum, item) => sum! + int.parse(item['priceTotal'].toString()));
    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปยอดชำระเงิน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ร้านอาหารเพลินใจ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      Text('ที่อยู๋ ที่อยู๋ ที่อยู๋ ที่อยู๋ ที่อยู๋', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'เลือกวิธีการชำระเงิน',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Column(
              children: List.generate(checkOcjective.length, (index) {
                // bool isSelected = selectedOcjective == index;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      checkOcjective[index],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Radio<int>(
                      value: index,
                      groupValue: selectedOcjective,
                      onChanged: (value) {
                        setState(() {
                          selectedOcjective = value!;
                        });
                      },
                    ),
                  ],
                );
              }),
            ),
            selectedOcjective == 0
                ? SizedBox.shrink()
                : Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 50,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text('ภาพถ่ายหลักฐานการเช็คอิน (ถ้าจำเป็น)', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                      ],
                    ),
                  ),
            SizedBox(
              height: 15,
            ),
            Text(
              'รายการสินค้่า',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: List.generate(
                  widget.itemsSelect.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/ice.png',
                                        fit: BoxFit.fitHeight,
                                        width: size.width * 0.25,
                                        height: size.height * 0.12,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          'assets/images/ice.png',
                                          width: size.width * 0.25,
                                          height: size.height * 0.12,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: Text(
                                            widget.itemsSelect[index]['name'],
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (widget.itemsSelect[index]['qty'] > 1) {
                                                  final current = widget.itemsSelect[index]['qty'];
                                                  final newValue = current! - 1;
                                                  widget.itemsSelect[index]['qty'] = newValue;
                                                  setState(() {
                                                    widget.itemsSelect[index]['priceTotal'] = (widget.itemsSelect[index]['qty'] * widget.itemsSelect[index]['price']);
                                                  });
                                                } else {
                                                  setState(() {
                                                    widget.itemsSelect.removeAt(index);
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: size.width * 0.07,
                                                height: size.width * 0.07,
                                                decoration: BoxDecoration(color: Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.itemsSelect[index]['qty'].toString(),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                final current = widget.itemsSelect[index]['qty'];
                                                final newValue = current! + 1;
                                                widget.itemsSelect[index]['qty'] = newValue;
                                                setState(() {
                                                  widget.itemsSelect[index]['priceTotal'] = (widget.itemsSelect[index]['qty'] * widget.itemsSelect[index]['price']);
                                                });
                                              },
                                              child: Container(
                                                width: size.width * 0.07,
                                                height: size.width * 0.07,
                                                decoration: BoxDecoration(color: Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.itemsSelect.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 35,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${widget.itemsSelect[index]['priceTotal'].toString()} บาท',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                final out = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return ChoiceDialog(
                      description: 'ยืนยันทำรายการใช่หรือไม่?',
                      type: 'save',
                      pressNo: () {
                        Navigator.pop(context, false);
                      },
                      pressYes: () {
                        Navigator.pop(context, true);
                      },
                    );
                  },
                );
                if (out == true) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SuccessPage();
                  }));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D3194),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ชำระเงิน $sumPrice บาท',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
