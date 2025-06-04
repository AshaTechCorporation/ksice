import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:ksice/constants.dart';

class LoginService {
  const LoginService();

  static Future customerCreate(
    String name,
    String detail,
    String phone,
    String date_work,
    String time_time,
    String lat,
    String lon,
    String card_fname,
    String card_lname,
    String card_birth_date,
    String card_gender,
    String card_idcard,
    String card_image,
    String card_address,
    String card_province,
    String card_district,
    String card_sub_district,
    String card_postal_code,
    List<String> member_shop_images,
    Map<String, dynamic> work_days,
    Map<String, dynamic> work_times,
  ) async {
    final url = Uri.https(publicUrl, '/public/api/member_app');
    final response = await http.post(url, body: {
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
    });
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}
