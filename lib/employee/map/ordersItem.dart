import 'package:flutter/material.dart';

class OrdersItemsPage extends StatefulWidget {
  const OrdersItemsPage({super.key});

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
    );
  }
}
