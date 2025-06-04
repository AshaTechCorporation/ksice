import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:ksice/constants.dart';

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
      throw Exception(data['message']);
    }
  }
}
