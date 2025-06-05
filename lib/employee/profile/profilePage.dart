import 'package:flutter/material.dart';
import 'package:ksice/login/Service/loginService.dart';
import 'package:ksice/login/loginPage.dart';
import 'package:ksice/model/user.dart';
import 'package:ksice/widgets/AlertDialogExit.dart';
import 'package:ksice/widgets/checkin_success_dialog.dart';
import 'package:ksice/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  User? user;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? pref;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getProfile();
    });
  }

  Future<void> getProfile() async {
    try {
      LoadingDialog.open(context);
      pref = await SharedPreferences.getInstance();
      final id = pref?.getInt('userID');
      final _user = await LoginService.getProfile(id: id!);
      LoadingDialog.close(context);

      if (!mounted) return;
      setState(() {
        user = _user;
        idController.text = _user.code.toString();
        firstNameController.text = _user.name ?? '';
        lastNameController.text = _user.name ?? '';
        phoneController.text = _user.phone ?? '';
      });
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
      backgroundColor: Colors.deepPurple, // ✅ สีพื้นหลัง
      body: Stack(
        children: [
          // ✅ กล่องโปรไฟล์สีขาว
          Positioned.fill(
            top: size.height * 0.15,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 70, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextField('พนักงานไอดี', idController),
                    buildTextField('ชื่อ', firstNameController),
                    buildTextField('นามสกุล', lastNameController),
                    buildTextField('เบอร์โทรศัพท์', phoneController),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          // showDialog(
                          //   context: context,ต้องออกจากระบบหรือไม่
                          //   builder: (context) => CheckInSuccessDialog(timeText: '12:00 น.'),
                          // );
                          final out = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ChoiceDialog(
                                description: 'ต้องออกจากระบบหรือไม่?',
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
                            if (!mounted) return;
                            await clearToken();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => true);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'ออกจากระบบ',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Avatar ซ้อนอยู่ด้านบน
          Positioned(
            top: size.height * 0.08,
            left: size.width / 2 - 50,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: user?.image != null && user!.image!.isNotEmpty
                    ? Image.network(
                        user!.image!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://cdn-icons-png.flaticon.com/512/2922/2922506.png',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.network(
                        'https://cdn-icons-png.flaticon.com/512/2922/2922506.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ), // fallback หากไม่มีรูป
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

Future<void> clearToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
