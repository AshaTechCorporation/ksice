import 'package:flutter/material.dart';
import 'package:ksice/constants.dart';
import 'package:ksice/employee/home/fristPage.dart';
import 'package:ksice/login/Service/loginController.dart';
import 'package:ksice/login/registerPage.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<LoginController>(
      builder: (context, controller, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.25),
                Text(
                  'แอปส่งน้ำแข็ง',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: titleTextColor),
                ),
                SizedBox(height: 8),
                Text(
                  'ยินดีต้อนรับ',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: titleTextColor),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'เบอร์โทรศัพท์ หรือ พนักงานไอดี',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'รหัสผ่าน',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'ลืมรหัสผ่าน ?',
                      style: TextStyle(color: forgetTextColor, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        LoadingDialog.open(context);
                        final _login = await controller.signIn(username: usernameController.text, password: passwordController.text);
                        LoadingDialog.close(context);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FristPage()), (route) => false);
                      } on Exception catch (e) {
                        if (!mounted) return;
                        LoadingDialog.close(context);
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 16, color: textWhiteColor),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'ยังไม่มีบัญชีผู้ใช้งาน ? ',
                            style: TextStyle(fontSize: 15),
                            children: [
                              TextSpan(
                                text: 'สมัครสมาชิกที่นี่',
                                style: TextStyle(color: forgetTextColor, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
