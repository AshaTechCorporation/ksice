import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ksice/employee/home/fristPage.dart';
import 'package:ksice/login/Service/loginController.dart';
import 'package:ksice/login/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;
late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky, // ซ่อน status + navigation bar และเด้งกลับมาเมื่อปัด
  );
  await initializeDateFormatting('th_TH', null);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),
      ],
      child: MaterialApp(
        title: 'KSI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
            fontFamily: 'SukhumvitSet'),
        home: token == null ? LoginPage() : FristPage(),
      ),
    );
  }
}
