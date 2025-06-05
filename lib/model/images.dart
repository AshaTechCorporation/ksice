import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class Images {
  final int id;
  int? ice_bucket_id;
  String? image;

  Images(
    this.id,
    this.ice_bucket_id,
    this.image,
  );

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}
