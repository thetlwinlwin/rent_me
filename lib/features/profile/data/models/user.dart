import 'package:json_annotation/json_annotation.dart';
import 'package:rent_me/features/profile/data/models/profile.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String username;
  final String email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final Profile? profile;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'date_joined')
  final DateTime? dateJoined;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.profile,
    required this.isActive,
    this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
