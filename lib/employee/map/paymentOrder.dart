import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksice/employee/map/successPage.dart';
import 'package:ksice/model/productcategory.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';

class PaymentOrderPage extends StatefulWidget {
  const PaymentOrderPage({super.key, required this.shop, required this.itemsSelect});
  final RoutePoints shop;
  final List<ProductCategory> itemsSelect;

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
  Map<int, int> quantities = {};
  File? checkInImage;
  final ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    for (var item in widget.itemsSelect) {
      quantities[item.id] = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    sumPrice = widget.itemsSelect.fold(0, (sum, item) => sum! + (100 ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปยอดชำระเงิน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                        Text(widget.shop.member_branch?.name ?? ' - ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                            '${widget.shop.member_branch?.address ?? ' - '} ${widget.shop.member_branch?.sub_district ?? ' - '}  ${widget.shop.member_branch?.district ?? ' - '}  ${widget.shop.member_branch?.province ?? ' - '}',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 8)),
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
                  : selectedOcjective == 0
                      ? SizedBox.shrink()
                      : Center(
                          child: GestureDetector(
                            onTap: () async {
                              final XFile? image = await picker.pickImage(source: ImageSource.camera);
                              if (image != null) {
                                setState(() {
                                  checkInImage = File(image.path);
                                });
                              }
                            },
                            child: Column(
                              children: [
                                checkInImage == null
                                    ? Icon(
                                        Icons.camera_alt_outlined,
                                        size: 50,
                                        color: Colors.grey.shade700,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          checkInImage!,
                                          width: size.width * 0.55,
                                          height: size.height * 0.22,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  'ภาพถ่ายหลักฐานการเช็คอิน (ถ้าจำเป็น)',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                ),
                              ],
                            ),
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
                  (index) {
                    final product = widget.itemsSelect[index];
                    final qty = quantities[product.id] ?? 1;
                    final price = 100;
                    final priceTotal = qty * price;

                    return Padding(
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
                                    child: Image.network(
                                      product.image ?? 'https://cdn-icons-png.flaticon.com/512/1046/1046857.png',
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
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                          product.name ?? '-',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (qty > 1) {
                                                  quantities[product.id] = qty - 1;
                                                } else {
                                                  widget.itemsSelect.removeAt(index);
                                                  quantities.remove(product.id);
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: size.width * 0.07,
                                              height: size.width * 0.07,
                                              decoration: BoxDecoration(color: const Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                                              child: const Icon(Icons.remove, size: 15),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            qty.toString(),
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                quantities[product.id] = qty + 1;
                                              });
                                            },
                                            child: Container(
                                              width: size.width * 0.07,
                                              height: size.width * 0.07,
                                              decoration: BoxDecoration(color: const Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                                              child: const Icon(Icons.add, size: 15),
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
                                        quantities.remove(product.id);
                                      });
                                    },
                                    child: const Icon(Icons.delete_outline, size: 35, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '$priceTotal บาท',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
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
