import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/trucks.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  String? code;
  String? name;
  String? username;
  String? password;
  String? phone;
  String? image;
  int? is_active;
  List<Trucks>? trucks;

  User(
    this.id,
    this.code,
    this.name,
    this.username,
    this.password,
    this.phone,
    this.image,
    this.is_active,
    this.trucks,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
