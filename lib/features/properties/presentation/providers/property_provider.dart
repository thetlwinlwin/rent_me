import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/properties/data/models/property.dart';
import 'package:rent_me/features/properties/data/models/property_filter.dart';
import 'package:rent_me/features/properties/data/properties_repository.dart';

final propertiesProvider = FutureProvider.family
    .autoDispose<List<Property>, PropertyFilter?>((ref, filter) async {
      final propertyRepository = ref.watch(propertyRepositoryProvider);
      return await propertyRepository.fetchProperties(filter: filter);
    });

final propertyDetailProvider = FutureProvider.family
    .autoDispose<Property, String>((ref, id) async {
      final propertyRepository = ref.watch(propertyRepositoryProvider);
      return await propertyRepository.fetchProperty(id: id);
    });

final townshipProvider = FutureProvider.autoDispose<List<Township>>((
  ref,
) async {
  final propertyRepository = ref.watch(propertyRepositoryProvider);
  return await propertyRepository.fetchTownships();
});
final propertyTypeProvider = FutureProvider.autoDispose<List<PropertyType>>((
  ref,
) async {
  final propertyRepository = ref.watch(propertyRepositoryProvider);
  return await propertyRepository.fetchPropertyTypes();
});

final amenityProvider = FutureProvider.autoDispose<List<Amenity>>((ref) async {
  final propertyRepository = ref.watch(propertyRepositoryProvider);
  return await propertyRepository.fetchAmenities();
});

final propertyAttributesProvider = FutureProvider.autoDispose<PropertyDetails>((
  ref,
) async {
  final townships = await ref.watch(townshipProvider.future);
  final propertyTypes = await ref.watch(propertyTypeProvider.future);
  final amenities = await ref.watch(amenityProvider.future);

  return PropertyDetails(
    amenities: amenities,
    propertyTypes: propertyTypes,
    townships: townships,
  );
});

final createPropertyProvider = FutureProvider.family
    .autoDispose<Property, CreatePropertyAttributes>((ref, data) async {
      final propertyRepository = ref.watch(propertyRepositoryProvider);
      return await propertyRepository.createProperty(
        newProperty: data.property,
        imgs: data.imgs,
      );
    });
