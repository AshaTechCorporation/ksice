import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  final int id;
  String? code;
  String? name;
  String? detail;
  String? card_fname;
  String? card_lname;
  String? phone;
  String? card_birth_date;
  String? card_gender;
  String? card_idcard;
  String? card_address;
  String? card_province;
  String? card_district;
  String? card_sub_district;
  String? card_postal_code;
  String? card_image;
  String? password;

  Member(
    this.id,
    this.code,
    this.name,
    this.detail,
    this.card_fname,
    this.card_lname,
    this.phone,
    this.card_birth_date,
    this.card_gender,
    this.card_idcard,
    this.card_address,
    this.card_province,
    this.card_district,
    this.card_sub_district,
    this.card_postal_code,
    this.card_image,
    this.password,
  );

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
