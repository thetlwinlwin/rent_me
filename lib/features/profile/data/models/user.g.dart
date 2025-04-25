// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  profile:
      json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  isActive: json['is_active'] as bool,
  dateJoined:
      json['date_joined'] == null
          ? null
          : DateTime.parse(json['date_joined'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'profile': instance.profile?.toJson(),
  'is_active': instance.isActive,
  'date_joined': instance.dateJoined?.toIso8601String(),
};
