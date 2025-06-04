import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/member.dart';

part 'maberBranch.g.dart';

@JsonSerializable()
class MaberBranch {
  final int id;
  String? code;
  int? member_id;
  String? name;
  String? address;
  String? province;
  String? district;
  String? sub_district;
  String? postal_code;
  String? latitude;
  String? longitude;
  String? contact_name;
  String? contact_phone;
  String? contact_phone2;
  int? is_active;
  Member? member;

  MaberBranch(
    this.id,
    this.code,
    this.member_id,
    this.name,
    this.address,
    this.province,
    this.district,
    this.sub_district,
    this.postal_code,
    this.latitude,
    this.longitude,
    this.contact_name,
    this.contact_phone,
    this.contact_phone2,
    this.is_active,
    this.member,
  );

  factory MaberBranch.fromJson(Map<String, dynamic> json) => _$MaberBranchFromJson(json);

  Map<String, dynamic> toJson() => _$MaberBranchToJson(this);
}
