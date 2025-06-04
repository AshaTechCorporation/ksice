import 'package:ksice/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:ksice/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  const LoginService();

  static Future login(
    String username,
    String password,
  ) async {
    final url = Uri.https(publicUrl, '/public/api/login_app_driver');
    final response = await http.post(url, body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final dataOut = {'token': data['token'], 'data': data['data']};
      return dataOut;
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<User> getProfile({required int id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, '/public/api/driver/$id');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers).timeout(const Duration(minutes: 1));

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return User.fromJson(data['data']);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
      // throw ApiException(data['message']);
    }
  }
}
