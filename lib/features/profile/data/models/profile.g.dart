// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
  isActive: json['is_active'] as bool,
  dateJoined: json['date_joined'] as String,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'profile': instance.profile.toJson(),
      'is_active': instance.isActive,
      'date_joined': instance.dateJoined,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  role: UserRole.fromApiKey(json['role'] as String),
  phoneNumber: json['phone_number'] as String?,
  address: json['address'] as String?,
  bio: json['bio'] as String?,
  profilePicture: json['profile_picture'] as String?,
  isVerifiedLandlord: json['is_verified_landlord'] as bool,
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'role': UserRole.toApiKey(instance.role),
  'phone_number': instance.phoneNumber,
  'address': instance.address,
  'bio': instance.bio,
  'profile_picture': instance.profilePicture,
  'is_verified_landlord': instance.isVerifiedLandlord,
  'updated_at': instance.updatedAt?.toIso8601String(),
};
