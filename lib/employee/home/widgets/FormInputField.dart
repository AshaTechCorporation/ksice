import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const FormInputField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
