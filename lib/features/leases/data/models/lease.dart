import 'package:json_annotation/json_annotation.dart';

import 'package:rent_me/features/profile/data/models/user.dart';

part 'lease.g.dart';

@JsonSerializable(explicitToJson: true)
class Lease {
  final int id;

  @JsonKey(name: 'property_details')
  final LeasePropertyDetails? propertyDetails;
  @JsonKey(name: 'tenant_details')
  final User? tenantDetails;

  @JsonKey(name: 'start_date', fromJson: _parseDate, toJson: _dateToString)
  final DateTime startDate;
  @JsonKey(name: 'end_date', fromJson: _parseDate, toJson: _dateToString)
  final DateTime endDate;
  final String status;
  @JsonKey(name: 'status_display')
  final String statusDisplay;
  @JsonKey(name: 'monthly_rent_at_signing', fromJson: _parseDouble)
  final double monthlyRentAtSigning;
  @JsonKey(name: 'deposit_paid_amount', fromJson: _parseDouble)
  final double depositPaidAmount;
  @JsonKey(
    name: 'deposit_paid_date',
    fromJson: _parseDateNullable,
    toJson: _dateToStringNullable,
  )
  final DateTime? depositPaidDate;
  @JsonKey(name: 'lease_document')
  final String? leaseDocument;
  @JsonKey(
    name: 'created_at',
    fromJson: _parseDateTimeNullable,
    toJson: _dateTimeToStringNullable,
  )
  final DateTime? createdAt;
  @JsonKey(
    name: 'updated_at',
    fromJson: _parseDateTimeNullable,
    toJson: _dateTimeToStringNullable,
  )
  final DateTime? updatedAt;

  Lease({
    required this.id,
    this.propertyDetails,
    this.tenantDetails,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.statusDisplay,
    required this.monthlyRentAtSigning,
    required this.depositPaidAmount,
    this.depositPaidDate,
    this.leaseDocument,
    this.createdAt,
    this.updatedAt,
  });

  factory Lease.fromJson(Map<String, dynamic> json) => _$LeaseFromJson(json);
  Map<String, dynamic> toJson() => _$LeaseToJson(this);

  static DateTime _parseDate(String dateString) {
    return DateTime.parse(dateString);
  }

  static DateTime? _parseDateNullable(String? dateString) {
    return dateString == null ? null : DateTime.tryParse(dateString);
  }

  static DateTime? _parseDateTimeNullable(String? dateTimeString) {
    return dateTimeString == null ? null : DateTime.tryParse(dateTimeString);
  }

  static String _dateToString(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  static String? _dateToStringNullable(DateTime? date) {
    return date == null ? null : _dateToString(date);
  }

  static String? _dateTimeToStringNullable(DateTime? date) {
    return date?.toIso8601String();
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

@JsonSerializable()
class LeasePropertyDetails {
  final int id;
  final String title;
  @JsonKey(name: 'address_line_1')
  final String address;

  LeasePropertyDetails({
    required this.id,
    required this.title,
    required this.address,
  });
  factory LeasePropertyDetails.fromJson(Map<String, dynamic> json) =>
      _$LeasePropertyDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$LeasePropertyDetailsToJson(this);
}

@JsonSerializable()
class CreateLease {
  @JsonKey(name: 'property')
  final int propertyId;
  @JsonKey(name: 'monthly_rent_at_signing', fromJson: _parseDouble)
  final double monthlyRentAtSigning;
  @JsonKey(name: 'deposit_paid_amount', fromJson: _parseDouble)
  final double depositPaidAmount;
  @JsonKey(name: 'start_date', fromJson: _parseDate, toJson: _dateToString)
  final DateTime startDate;
  @JsonKey(name: 'end_date', fromJson: _parseDate, toJson: _dateToString)
  final DateTime endDate;

  CreateLease({
    required this.propertyId,
    required this.monthlyRentAtSigning,
    required this.depositPaidAmount,
    required this.startDate,
    required this.endDate,
  });

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(String dateString) {
    return DateTime.parse(dateString);
  }

  static String _dateToString(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  factory CreateLease.fromJson(Map<String, dynamic> json) =>
      _$CreateLeaseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateLeaseToJson(this);
}
