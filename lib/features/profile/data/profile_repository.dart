import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/core/network/dio_client.dart';
import 'package:rent_me/features/profile/data/models/profile.dart';

class UserProfileRepository {
  final Dio _dio;

  UserProfileRepository(this._dio);
  Future<UserProfile> fetchProfile() async {
    try {
      final response = await _dio.get(APIConstants.currentUser);
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch properties: Status code ${response.statusCode}',
        );
      }
      final data = response.data as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    } on DioException {
      throw Exception('Network error fetching profile. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> updateProfile({
    required String? phoneNumber,
    required String? bio,
    required File? profilePicture,
  }) async {
    try {
      final formData = FormData();

      if (phoneNumber != null) {
        formData.fields.add(MapEntry('phone_number', phoneNumber));
      }
      if (bio != null) {
        formData.fields.add(MapEntry('bio', bio));
      }

      if (profilePicture != null) {
        formData.files.add(
          MapEntry(
            'profile_picture',
            await MultipartFile.fromFile(profilePicture.path),
          ),
        );
      }

      final response = await _dio.patch(
        APIConstants.currentUserProfile,
        data: formData,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch properties: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error updating profile. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }
}

final userProfileRepositoryProvider =
    Provider.autoDispose<UserProfileRepository>((ref) {
      final dio = ref.watch(dioClientProvider);
      return UserProfileRepository(dio);
    });
