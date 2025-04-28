import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/core/exceptions/auth_exception.dart';

import 'package:rent_me/core/network/dio_client.dart';
import 'package:rent_me/core/storage/secure_storage.dart';
import 'package:rent_me/features/profile/data/models/user.dart';
import 'package:rent_me/shared/enums.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;

  AuthRepository(this._dio, this._secureStorage);

  Future<String> login(String emailOrUsername, String password) async {
    try {
      final response = await _dio.post(
        APIConstants.login,
        data: {'username': emailOrUsername, 'password': password},
      );

      if (response.statusCode == 200 && response.data['key'] != null) {
        final token = response.data['key'] as String;

        await _secureStorage.write(
          key: AppConstants.authTokenKey,
          value: token,
        );

        return token;
      } else {
        throw AuthException('Unexpected response from server.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final data = e.response?.data;

        if (data is Map && data.containsKey('non_field_errors')) {
          final msg = data['non_field_errors'][0] ?? 'Invalid login.';
          throw AuthException(msg);
        }

        if (data is Map && data.containsKey('username')) {
          throw AuthException('Username: ${data['username'][0]}');
        }

        if (data is Map && data.containsKey('password')) {
          throw AuthException('Password: ${data['password'][0]}');
        }

        throw AuthException('Invalid credentials.');
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw AuthException('Network error. Please try again.');
      }

      throw AuthException('Something went wrong. Please try again.');
    } catch (e) {
      throw AuthException('Unexpected error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.authTokenKey);
    await _secureStorage.delete(key: AppConstants.emailStatus);
    await _secureStorage.delete(key: AppConstants.themeModeKey);

    try {
      await _dio.post(APIConstants.logout);
    } catch (e) {
      throw AuthException('Unknown Error occur during logout');
    }
  }

  Future<void> verifyEmail({required String key}) async {
    try {
      await _dio.post(APIConstants.verifyEmail, data: {'key': key});
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException(
          "Link expired or invalid. Request a new verification email.",
        );
      }
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get(APIConstants.currentUser);
      if (response.statusCode == 200) {
        // Use User.fromJson here
        return User.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch user data.');
      }
    } on DioException {
      throw Exception('Could not fetch user data.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> register({
    required String email,
    required String password1,
    required String password2,
    required String username,
    required String firstName,
    required String lastName,
    required UserRole? role,
  }) async {
    try {
      final data = {
        'email': email,
        'password1': password1,
        'password2': password2,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'role': role?.apiKey ?? UserRole.tenant.apiKey,
      };

      final response = await _dio.post(APIConstants.registration, data: data);
      await _secureStorage.write(key: AppConstants.emailStatus, value: 'PE');

      if (response.statusCode != 201) {
        throw AuthException('Unexpected server response.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data;
        if (errors is Map) {
          List<String> messages = [];
          errors.forEach((field, value) {
            if (value is List && value.isNotEmpty) {
              final label = field.toString();
              messages.add('$label: ${value.first}');
            }
          });
          if (messages.isNotEmpty) {
            throw AuthException(messages.join('\n'));
          }
          throw AuthException('Please correct the errors and try again.');
        }
      }

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw AuthException('Network error. Please check your connection.');
      }

      throw AuthException('Registration failed. Please try again.');
    } catch (e) {
      throw AuthException('Unexpected error: ${e.toString()}');
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(dio, storage);
});
