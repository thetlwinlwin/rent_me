import 'package:json_annotation/json_annotation.dart';
import 'package:rent_me/shared/enums.dart';

part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile {
  final int id;
  final String username;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final Profile profile;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'date_joined')
  final String dateJoined;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profile,
    required this.isActive,
    required this.dateJoined,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class Profile {
  @JsonKey(fromJson: UserRole.fromApiKey, toJson: UserRole.toApiKey)
  final UserRole role;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? address;
  final String? bio;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @JsonKey(name: 'is_verified_landlord')
  final bool isVerifiedLandlord;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  Profile({
    required this.role,
    this.phoneNumber,
    this.address,
    this.bio,
    this.profilePicture,
    required this.isVerifiedLandlord,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class CounterPartProfile {
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? address;
  @JsonKey(fromJson: UserRole.fromApiKey, toJson: UserRole.toApiKey)
  final UserRole role;

  CounterPartProfile({this.phoneNumber, this.address, required this.role});

  factory CounterPartProfile.fromJson(Map<String, dynamic> json) =>
      _$CounterPartProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CounterPartProfileToJson(this);
}
