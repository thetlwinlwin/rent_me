import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:rent_me/shared/enums.dart';

part 'property.g.dart';

@JsonSerializable(explicitToJson: true)
class Property {
  final int id;
  final String title;
  final String description;
  @JsonKey(name: 'address_line_1')
  final String addressLine1;
  @JsonKey(name: 'address_line_2')
  final String? addressLine2;
  final Township township;
  @JsonKey(name: 'latitude')
  final String latitude;
  @JsonKey(name: 'longitude')
  final String longitude;
  @JsonKey(name: 'price_per_month')
  final String pricePerMonth;
  @JsonKey(name: 'deposit_amount')
  final String depositAmount;
  final int bedrooms;
  final String bathrooms;
  @JsonKey(name: 'is_furnished')
  final bool isFurnished;
  @JsonKey(name: 'pet_policy')
  final String petPolicy;
  @JsonKey(name: 'parking_type')
  final String parkingType;
  final List<PropertyImage?> images;
  @JsonKey(
    name: 'availability_status',
    fromJson: AvailabilityStatus.fromApiKey,
    toJson: AvailabilityStatus.toApiKey,
  )
  final AvailabilityStatus availabilityStatus;
  @JsonKey(name: 'owner_phone')
  final String ownerPhone;
  @JsonKey(name: 'owner_is_verified')
  final bool ownerIsVerified;
  @JsonKey(name: 'property_type')
  final PropertyType propertyType;
  final List<Amenity> amenities;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.addressLine1,
    this.addressLine2,
    required this.township,
    required this.latitude,
    required this.longitude,
    required this.pricePerMonth,
    required this.depositAmount,
    required this.bedrooms,
    required this.bathrooms,
    required this.isFurnished,
    required this.petPolicy,
    required this.parkingType,
    required this.availabilityStatus,
    required this.ownerPhone,
    required this.ownerIsVerified,
    required this.propertyType,
    required this.amenities,
    required this.images,
  });

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

@JsonSerializable()
class Township {
  @JsonKey(name: 'id')
  final int townshipId;
  final String name;
  @JsonKey(name: 'city_district_name')
  final String cityDistrictName;
  @JsonKey(name: 'region_state_name')
  final String regionStateName;

  Township({
    required this.townshipId,
    required this.name,
    required this.cityDistrictName,
    required this.regionStateName,
  });

  factory Township.fromJson(Map<String, dynamic> json) =>
      _$TownshipFromJson(json);
  Map<String, dynamic> toJson() => _$TownshipToJson(this);

  @override
  String toString() {
    return '$name, ${regionStateName.replaceAll('Region', '')}';
  }
}

@JsonSerializable()
class PropertyImage {
  @JsonKey(name: 'id')
  final int imageId;
  @JsonKey(name: 'image_url')
  final String imgUrl;

  PropertyImage({required this.imageId, required this.imgUrl});

  factory PropertyImage.fromJson(Map<String, dynamic> json) =>
      _$PropertyImageFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyImageToJson(this);
}

@JsonSerializable()
class PropertyType {
  @JsonKey(name: 'id')
  final int propertyId;
  final String name;

  PropertyType({required this.propertyId, required this.name});

  factory PropertyType.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypeFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyTypeToJson(this);
}

@JsonSerializable()
class Amenity {
  @JsonKey(name: 'id')
  final int amenityId;
  final String name;

  Amenity({required this.amenityId, required this.name});

  factory Amenity.fromJson(Map<String, dynamic> json) =>
      _$AmenityFromJson(json);
  Map<String, dynamic> toJson() => _$AmenityToJson(this);
}

class PropertyDetails {
  final List<Amenity> amenities;
  final List<PropertyType> propertyTypes;
  final List<Township> townships;

  PropertyDetails({
    required this.amenities,
    required this.propertyTypes,
    required this.townships,
  });
}

@JsonSerializable()
class CreateProperty {
  final String title;
  final String description;
  @JsonKey(name: 'address_line_1')
  final String addressLine1;
  @JsonKey(name: 'address_line_2')
  final String? addressLine2;
  @JsonKey(name: 'price_per_month')
  final String pricePerMonth;
  @JsonKey(name: 'deposit_amount')
  final String depositAmount;
  @JsonKey(name: 'township_id')
  final int townshipId;
  @JsonKey(name: 'property_type_id')
  final int propertyTypeid;
  @JsonKey(name: 'amenity_ids')
  final List<int> amenityIds;
  final int bedrooms;
  final double bathrooms;
  final double latitude;
  final double longitude;

  CreateProperty({
    required this.title,
    required this.description,
    required this.addressLine1,
    required this.addressLine2,
    required this.pricePerMonth,
    required this.depositAmount,
    required this.amenityIds,
    required this.propertyTypeid,
    required this.townshipId,
    required this.bedrooms,
    required this.bathrooms,
    required this.latitude,
    required this.longitude,
  });
  factory CreateProperty.fromJson(Map<String, dynamic> json) =>
      _$CreatePropertyFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePropertyToJson(this);
}

class CreatePropertyAttributes {
  final CreateProperty property;
  final List<File?> imgs;

  CreatePropertyAttributes({required this.property, required this.imgs});
}
