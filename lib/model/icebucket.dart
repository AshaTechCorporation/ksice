import 'package:json_annotation/json_annotation.dart';
import 'package:ksice/model/images.dart';

part 'icebucket.g.dart';

@JsonSerializable()
class IceBucket {
  final int id;
  String? code;
  String? size_name;
  int? qty;
  String? remark;
  List<Images>? images;

  IceBucket(
    this.id,
    this.code,
    this.size_name,
    this.qty,
    this.remark,
    this.images,
  );

  factory IceBucket.fromJson(Map<String, dynamic> json) =>
      _$IceBucketFromJson(json);

  Map<String, dynamic> toJson() => _$IceBucketToJson(this);
}
