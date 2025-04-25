// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  addressLine1: json['address_line_1'] as String,
  addressLine2: json['address_line_2'] as String?,
  township: Township.fromJson(json['township'] as Map<String, dynamic>),
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
  pricePerMonth: json['price_per_month'] as String,
  depositAmount: json['deposit_amount'] as String,
  bedrooms: (json['bedrooms'] as num).toInt(),
  bathrooms: json['bathrooms'] as String,
  isFurnished: json['is_furnished'] as bool,
  petPolicy: json['pet_policy'] as String,
  parkingType: json['parking_type'] as String,
  availabilityStatus: AvailabilityStatus.fromApiKey(
    json['availability_status'] as String,
  ),
  ownerPhone: json['owner_phone'] as String,
  ownerIsVerified: json['owner_is_verified'] as bool,
  propertyType: PropertyType.fromJson(
    json['property_type'] as Map<String, dynamic>,
  ),
  amenities:
      (json['amenities'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
  images:
      (json['images'] as List<dynamic>)
          .map(
            (e) =>
                e == null
                    ? null
                    : PropertyImage.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'address_line_1': instance.addressLine1,
  'address_line_2': instance.addressLine2,
  'township': instance.township.toJson(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'price_per_month': instance.pricePerMonth,
  'deposit_amount': instance.depositAmount,
  'bedrooms': instance.bedrooms,
  'bathrooms': instance.bathrooms,
  'is_furnished': instance.isFurnished,
  'pet_policy': instance.petPolicy,
  'parking_type': instance.parkingType,
  'images': instance.images.map((e) => e?.toJson()).toList(),
  'availability_status': AvailabilityStatus.toApiKey(
    instance.availabilityStatus,
  ),
  'owner_phone': instance.ownerPhone,
  'owner_is_verified': instance.ownerIsVerified,
  'property_type': instance.propertyType.toJson(),
  'amenities': instance.amenities.map((e) => e.toJson()).toList(),
};

Township _$TownshipFromJson(Map<String, dynamic> json) => Township(
  townshipId: (json['id'] as num).toInt(),
  name: json['name'] as String,
  cityDistrictName: json['city_district_name'] as String,
  regionStateName: json['region_state_name'] as String,
);

Map<String, dynamic> _$TownshipToJson(Township instance) => <String, dynamic>{
  'id': instance.townshipId,
  'name': instance.name,
  'city_district_name': instance.cityDistrictName,
  'region_state_name': instance.regionStateName,
};

PropertyImage _$PropertyImageFromJson(Map<String, dynamic> json) =>
    PropertyImage(
      imageId: (json['id'] as num).toInt(),
      imgUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$PropertyImageToJson(PropertyImage instance) =>
    <String, dynamic>{'id': instance.imageId, 'image_url': instance.imgUrl};

PropertyType _$PropertyTypeFromJson(Map<String, dynamic> json) => PropertyType(
  propertyId: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$PropertyTypeToJson(PropertyType instance) =>
    <String, dynamic>{'id': instance.propertyId, 'name': instance.name};

Amenity _$AmenityFromJson(Map<String, dynamic> json) => Amenity(
  amenityId: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$AmenityToJson(Amenity instance) => <String, dynamic>{
  'id': instance.amenityId,
  'name': instance.name,
};

CreateProperty _$CreatePropertyFromJson(Map<String, dynamic> json) =>
    CreateProperty(
      title: json['title'] as String,
      description: json['description'] as String,
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String?,
      pricePerMonth: json['price_per_month'] as String,
      depositAmount: json['deposit_amount'] as String,
      amenityIds:
          (json['amenity_ids'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toList(),
      propertyTypeid: (json['property_type_id'] as num).toInt(),
      townshipId: (json['township_id'] as num).toInt(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CreatePropertyToJson(CreateProperty instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'address_line_1': instance.addressLine1,
      'address_line_2': instance.addressLine2,
      'price_per_month': instance.pricePerMonth,
      'deposit_amount': instance.depositAmount,
      'township_id': instance.townshipId,
      'property_type_id': instance.propertyTypeid,
      'amenity_ids': instance.amenityIds,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
