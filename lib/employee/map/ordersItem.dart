import 'package:flutter/material.dart';
import 'package:ksice/employee/home/services/homeService.dart';
import 'package:ksice/employee/map/paymentOrder.dart';
import 'package:ksice/model/productcategory.dart';
import 'package:ksice/model/routePoints.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';

class OrdersItemsPage extends StatefulWidget {
  const OrdersItemsPage({super.key, required this.shop});
  final RoutePoints shop;

  @override
  State<OrdersItemsPage> createState() => _OrdersItemsPageState();
}

class _OrdersItemsPageState extends State<OrdersItemsPage> {
  List<ProductCategory> productCategory = [];
  List<ProductCategory> selectedProducts = [];
  Map<int, int> quantities = {};
  Map<int, bool> selectedStatus = {}; // productId -> true/false

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getProductCategory();
    });
  }

  Future<void> getProductCategory() async {
    try {
      LoadingDialog.open(context);
      final _productCategory = await HomeService.getProductCategory();
      LoadingDialog.close(context);
      if (!mounted) return;
      if (_productCategory.isNotEmpty) {
        productCategory = _productCategory;
      }
      setState(() {});
    } on Exception catch (e) {
      LoadingDialog.close(context);
      if (!mounted) return;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ErrorDialog(
            description: '${e}',
            pressYes: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

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
                    productCategory.length,
                    (index) {
                      final product = productCategory[index];
                      final isSelected = selectedStatus[product.id] ?? false;
                      final imageUrl = product.image;

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
                                        imageUrl ?? '',
                                        fit: BoxFit.fitHeight,
                                        width: size.width * 0.25,
                                        height: size.height * 0.12,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          'assets/images/ice.png', // ✅ รูป fallback ใช้งานได้จริง
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
                                            product.name ?? 'ไม่ทราบชื่อ',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: Text(
                                            '100 บาท',
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedStatus[product.id] = !isSelected;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: 16),
                                    width: size.width * 0.15,
                                    height: size.width * 0.15,
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.red : const Color(0xFF2D3194),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        isSelected ? Icons.delete : Icons.add,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final selectedItems = productCategory.where((p) => selectedStatus[p.id] == true).toList();
                if (selectedItems.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentOrderPage(
                      shop: widget.shop,
                      itemsSelect: selectedItems,
                    );
                  }));
                } else {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ErrorDialog(
                        description: 'กรุณาเลือกสินค้า',
                        pressYes: () => Navigator.pop(context),
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
