// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      (json['id'] as num).toInt(),
      json['code'] as String?,
      json['name'] as String?,
      json['detail'] as String?,
      json['card_fname'] as String?,
      json['card_lname'] as String?,
      json['phone'] as String?,
      json['card_birth_date'] as String?,
      json['card_gender'] as String?,
      json['card_idcard'] as String?,
      json['card_address'] as String?,
      json['card_province'] as String?,
      json['card_district'] as String?,
      json['card_sub_district'] as String?,
      json['card_postal_code'] as String?,
      json['card_image'] as String?,
      json['password'] as String?,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'detail': instance.detail,
      'card_fname': instance.card_fname,
      'card_lname': instance.card_lname,
      'phone': instance.phone,
      'card_birth_date': instance.card_birth_date,
      'card_gender': instance.card_gender,
      'card_idcard': instance.card_idcard,
      'card_address': instance.card_address,
      'card_province': instance.card_province,
      'card_district': instance.card_district,
      'card_sub_district': instance.card_sub_district,
      'card_postal_code': instance.card_postal_code,
      'card_image': instance.card_image,
      'password': instance.password,
    };
