import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/api_constants.dart';
import 'package:rent_me/core/network/dio_client.dart';
import 'package:rent_me/features/properties/data/models/property.dart';
import 'package:rent_me/features/properties/data/models/property_filter.dart';
import 'package:rent_me/shared/widgets/extensions_methods.dart';

class PropertyRepository {
  final Dio _dio;

  PropertyRepository(this._dio);

  Future<List<Property>> fetchProperties({PropertyFilter? filter}) async {
    try {
      final response = await _dio.get(
        APIConstants.properties,
        queryParameters: filter?.toQueryParams(),
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as List;
        return data
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch properties: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching properties. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred.$e');
    }
  }

  Future<List<Township>> fetchTownships() async {
    try {
      final response = await _dio.get(APIConstants.townships);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as List;
        return data
            .map((e) => Township.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch Townships: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching townships. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<List<PropertyType>> fetchPropertyTypes() async {
    try {
      final response = await _dio.get(APIConstants.propertyTypes);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as List;
        return data
            .map((e) => PropertyType.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch Property Types: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception(
        'Network error fetching property types. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<List<Amenity>> fetchAmenities() async {
    try {
      final response = await _dio.get(APIConstants.amenities);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as List;
        return data
            .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch Property Types: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception(
        'Network error fetching property types. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<Property> createProperty({
    required CreateProperty newProperty,
    required List<File?> imgs,
  }) async {
    try {
      final response = await _dio.post(
        APIConstants.properties,
        data: newProperty.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final property = Property.fromJson(data);

        if (imgs.isNotEmpty) {
          final List<MultipartFile> imageFiles = [];
          List<Future<MultipartFile>> futures =
              imgs
                  .where((e) => e != null)
                  .map((file) => MultipartFile.fromFile(file!.path))
                  .toList();

          imageFiles.addAll(await Future.wait(futures));
          final imgData = FormData.fromMap({'images': imageFiles});

          final uploadImgs = await _dio.post(
            APIConstants.propertyImagesBase.swapId(id: property.id.toString()),
            data: imgData,
          );
          if (uploadImgs.statusCode != 201) {
            throw Exception(
              'Failed to create property: Status code ${response.statusCode}',
            );
          }
        }
        return property;
      } else {
        throw Exception(
          'Failed to create property: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error creating property. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<Property> fetchProperty({required String id}) async {
    try {
      final response = await _dio.get(
        APIConstants.propertyDetail.replaceFirst('{id}', id),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final property = Property.fromJson(data);
        return property;
      } else {
        throw Exception(
          'Failed to fetch properties: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching properties. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }
}

final propertyRepositoryProvider = Provider.autoDispose<PropertyRepository>((
  ref,
) {
  final dio = ref.watch(dioClientProvider);
  return PropertyRepository(dio);
});
