import 'package:flutter/material.dart';

class CheckInSuccessDialog extends StatelessWidget {
  final String timeText;

  const CheckInSuccessDialog({super.key, required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon_success.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 24),
            Text(
              'เวลาเช็คอิน $timeText',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
