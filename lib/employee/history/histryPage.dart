import 'package:flutter/material.dart';

class HistryPage extends StatefulWidget {
  const HistryPage({super.key});

  @override
  State<HistryPage> createState() => _HistryPageState();
}

class _HistryPageState extends State<HistryPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
    );
  }
}