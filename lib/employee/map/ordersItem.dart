import 'package:flutter/material.dart';
import 'package:ksice/employee/map/paymentOrder.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';

class OrdersItemsPage extends StatefulWidget {
  const OrdersItemsPage({super.key, required this.shop});
  final Map<String, dynamic> shop;

  @override
  State<OrdersItemsPage> createState() => _OrdersItemsPageState();
}

class _OrdersItemsPageState extends State<OrdersItemsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสินค้า'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  children: List.generate(
                      items.length,
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
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.4,
                                              child: Text(
                                                items[index]['name'],
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.4,
                                              child: Text(
                                                '${items[index]['price'].toString()} บาท',
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    items[index]['selectItem'] == false
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                items[index]['selectItem'] = true;
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: 16),
                                              width: size.width * 0.15,
                                              height: size.width * 0.15,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF2D3194),
                                                border: Border.all(
                                                  color: Colors.black12,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                items[index]['selectItem'] = false;
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: 16),
                                              width: size.width * 0.15,
                                              height: size.width * 0.15,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                border: Border.all(
                                                  color: Colors.black12,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                    // Row(
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           // if (items[index]['qty'] > 1) {
                                    //           final current = items[index]['qty'];
                                    //           final newValue = current! - 1;
                                    //           items[index]['qty'] = newValue;
                                    //           setState(() {
                                    //             // docScan[index].totalPrice = (double.parse(docScan[index].qty!.text) * double.parse(docScan[index].item!.sup_item!.price!));
                                    //           });
                                    //           // }
                                    //         },
                                    //         child: Container(
                                    //           width: size.width * 0.07,
                                    //           height: size.width * 0.07,
                                    //           decoration: BoxDecoration(color: Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                                    //           child: Icon(
                                    //             Icons.remove,
                                    //             size: 15,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       Text(
                                    //         items[index]['qty'].toString(),
                                    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                                    //         maxLines: 1,
                                    //         overflow: TextOverflow.ellipsis,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           final current = items[index]['qty'];
                                    //           final newValue = current! + 1;
                                    //           items[index]['qty'] = newValue;
                                    //           setState(() {
                                    //             // docScan[index].totalPrice = (double.parse(docScan[index].qty!.text) * double.parse(docScan[index].item!.sup_item!.price!));
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           width: size.width * 0.07,
                                    //           height: size.width * 0.07,
                                    //           decoration: BoxDecoration(color: Color(0xFFCFD8DC), borderRadius: BorderRadius.circular(6)),
                                    //           child: Icon(
                                    //             Icons.add,
                                    //             size: 15,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   )
                                  ],
                                ),
                                Divider()
                              ],
                            ),
                          )),
                )
              ],
            ),
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
              onPressed: () {
                List<Map<String, dynamic>> itemsSelect = [];
                for (var i = 0; i < items.length; i++) {
                  if (items[i]['selectItem'] == true) {
                    itemsSelect.add(items[i]);
                  }
                }
                if (itemsSelect.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentOrderPage(
                      shop: widget.shop,
                      itemsSelect: itemsSelect,
                    );
                  }));
                } else {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ErrorDialog(
                        description: 'กรุณาเลือกสินค้า',
                        pressYes: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D3194),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ส่งสินค้า',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> items = [
    {
      "name": "น้ำแข็งก้อน",
      "price": 100,
      "priceTotal": 100,
      "qty": 1,
      "selectItem": false,
    },
    {
      "name": "น้ำแข็งเกล็ด",
      "price": 120,
      "priceTotal": 120,
      "qty": 1,
      "selectItem": false,
    },
    {
      "name": "น้ำแข็งมือ",
      "price": 140,
      "priceTotal": 140,
      "qty": 1,
      "selectItem": false,
    },
  ];
}
