import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ksice/constants.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'แอปส่งน้ำแข็ง',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: titleTextColor),
            ),
            SizedBox(height: 8),
            Text(
              'ยินดีต้อนรับ',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: titleTextColor),
            ),
            SizedBox(height: 24),

            // 🔹 เบอร์โทร/รหัสพนักงาน
            TextField(
              decoration: InputDecoration(
                hintText: 'เบอร์โทรศัพท์ หรือ ไอดีพนักงาน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 12),

            // 🔹 รหัสผ่าน
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'รหัสผ่าน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 12),

            // 🔹 ยืนยันรหัสผ่าน
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'ยืนยันรหัสผ่าน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 24),

            // 🔵 ปุ่มสมัครสมาชิก
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // ปุ่มสีน้ำเงิน
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: สมัครสมาชิก
                },
                child: Text(
                  'สมัครสมาชิก',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textWhiteColor),
                ),
              ),
            ),

            SizedBox(height: 16),

            // 🔗 ลิงก์เข้าสู่ระบบ
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'มีบัญชีอยู่แล้วใช่ไหม ? ',
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                  children: [
                    TextSpan(
                      text: 'เข้าสู่ระบบที่นี่',
                      style: TextStyle(
                        color: forgetTextColor,
                        fontWeight: FontWeight.bold, fontSize: 15
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
