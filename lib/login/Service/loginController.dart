import 'package:flutter/material.dart';
import 'package:ksice/login/Service/loginService.dart';
import 'package:ksice/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  LoginController({this.loginService = const LoginService()});
  LoginService? loginService;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? pref;
  User? user;

  Future signIn({required String username, required String password}) async {
    final data = await LoginService.login(username, password);
    user = User.fromJson(data['data']);
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('userID', user!.id);
    await prefs.setString('token', data['token']);
    notifyListeners();
    return data;
  }

  Future<void> initialize() async {
    pref = await SharedPreferences.getInstance();
    final id = pref?.getInt('userID');

    user = await LoginService.getProfile(id: id!);

    notifyListeners();
  }
}
