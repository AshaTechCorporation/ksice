import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.keyboard_arrow_down),
        SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}