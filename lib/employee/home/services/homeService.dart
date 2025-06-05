import 'dart:convert' as convert;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ksice/constants.dart';
import 'package:ksice/model/productcategory.dart';
import 'package:ksice/model/driverCar/driverCar.dart';
import 'package:ksice/utils/ApiExeption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  const HomeService();

  static Future customerCreate({
    required String name,
    required String detail,
    required String phone,
    required String date_work,
    required String time_time,
    required String lat,
    required String lon,
    required String card_fname,
    required String card_lname,
    required String card_birth_date,
    required String card_gender,
    required String card_idcard,
    required String card_image,
    required String card_address,
    required String card_province,
    required String card_district,
    required String card_sub_district,
    required String card_postal_code,
    required List<String> member_shop_images,
    required Map<String, dynamic> work_days,
    required Map<String, dynamic> work_times,
  }) async {
    final url = Uri.https(publicUrl, '/public/api/member_app');
    var headers = {
      // 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.post(url,
        headers: headers,
        body: convert.jsonEncode({
          "name": name,
          "detail": detail,
          "phone": phone,
          "date_work": date_work,
          "time_time": time_time,
          "lat": lat,
          "lon": lon,
          "member_shop_images": member_shop_images,
          "card_fname": card_fname,
          "card_lname": card_lname,
          "card_birth_date": card_birth_date,
          "card_gender": card_gender,
          "card_idcard": card_idcard,
          "card_image": card_image,
          "card_address": card_address,
          "card_province": card_province,
          "card_district": card_district,
          "card_sub_district": card_sub_district,
          "card_postal_code": card_postal_code,
          "work_days": work_days,
          "work_times": work_times,
          "member_product_requests": [
            {"product_id": 1, "product_unit_id": 1, "qty": 10}
          ],
          "member_bucket_requests": [
            {"ice_bucket_id": 1, "qty": 10}
          ]
        }));
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

  static Future checkInPoint({
    required int route_id,
    required int route_point_id,
    required double latitude,
    required double longitude,
    String? image,
  }) async {
    final url = Uri.https(publicUrl, '/public/api/driver_check_in_point');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userID = prefs.getInt('userID');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: convert.jsonEncode({
          "driver_id": userID,
          "route_id": route_id,
          "route_point_id": route_point_id,
          "latitude": 13.7273450,
          "longitude": 100.7471930,
          "image": image,
        }));
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

  static Future<List<ProductCategory>> getProductCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, '/public/api/get_product/1');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers).timeout(const Duration(minutes: 1));

      if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => ProductCategory.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }
  static Future<List<DriverCar>> getListDriver({
    String? search,
    String? status,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(publicUrl, '/public/api/get_driver');
    final response = await http.get(url, headers: headers).timeout(const Duration(minutes: 1));
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => DriverCar.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }
}
