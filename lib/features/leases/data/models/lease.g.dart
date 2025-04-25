// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lease _$LeaseFromJson(Map<String, dynamic> json) => Lease(
  id: (json['id'] as num).toInt(),
  propertyDetails:
      json['property_details'] == null
          ? null
          : LeasePropertyDetails.fromJson(
            json['property_details'] as Map<String, dynamic>,
          ),
  tenantDetails:
      json['tenant_details'] == null
          ? null
          : User.fromJson(json['tenant_details'] as Map<String, dynamic>),
  startDate: Lease._parseDate(json['start_date'] as String),
  endDate: Lease._parseDate(json['end_date'] as String),
  status: json['status'] as String,
  statusDisplay: json['status_display'] as String,
  monthlyRentAtSigning: Lease._parseDouble(json['monthly_rent_at_signing']),
  depositPaidAmount: Lease._parseDouble(json['deposit_paid_amount']),
  depositPaidDate: Lease._parseDateNullable(
    json['deposit_paid_date'] as String?,
  ),
  leaseDocument: json['lease_document'] as String?,
  createdAt: Lease._parseDateTimeNullable(json['created_at'] as String?),
  updatedAt: Lease._parseDateTimeNullable(json['updated_at'] as String?),
);

Map<String, dynamic> _$LeaseToJson(Lease instance) => <String, dynamic>{
  'id': instance.id,
  'property_details': instance.propertyDetails?.toJson(),
  'tenant_details': instance.tenantDetails?.toJson(),
  'start_date': Lease._dateToString(instance.startDate),
  'end_date': Lease._dateToString(instance.endDate),
  'status': instance.status,
  'status_display': instance.statusDisplay,
  'monthly_rent_at_signing': instance.monthlyRentAtSigning,
  'deposit_paid_amount': instance.depositPaidAmount,
  'deposit_paid_date': Lease._dateToStringNullable(instance.depositPaidDate),
  'lease_document': instance.leaseDocument,
  'created_at': Lease._dateTimeToStringNullable(instance.createdAt),
  'updated_at': Lease._dateTimeToStringNullable(instance.updatedAt),
};

LeasePropertyDetails _$LeasePropertyDetailsFromJson(
  Map<String, dynamic> json,
) => LeasePropertyDetails(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  address: json['address_line_1'] as String,
);

Map<String, dynamic> _$LeasePropertyDetailsToJson(
  LeasePropertyDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'address_line_1': instance.address,
};

CreateLease _$CreateLeaseFromJson(Map<String, dynamic> json) => CreateLease(
  propertyId: (json['property'] as num).toInt(),
  monthlyRentAtSigning: CreateLease._parseDouble(
    json['monthly_rent_at_signing'],
  ),
  depositPaidAmount: CreateLease._parseDouble(json['deposit_paid_amount']),
  startDate: CreateLease._parseDate(json['start_date'] as String),
  endDate: CreateLease._parseDate(json['end_date'] as String),
);

Map<String, dynamic> _$CreateLeaseToJson(CreateLease instance) =>
    <String, dynamic>{
      'property': instance.propertyId,
      'monthly_rent_at_signing': instance.monthlyRentAtSigning,
      'deposit_paid_amount': instance.depositPaidAmount,
      'start_date': CreateLease._dateToString(instance.startDate),
      'end_date': CreateLease._dateToString(instance.endDate),
    };
