// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/core/storage/secure_storage.dart';
// Import the auth provider to access the notifier
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_state.dart';

class DioClient {
  final SecureStorage _storage;
  final Ref _ref; // Store Ref to access providers later
  late final Dio dio;

  // Modify constructor to accept Ref
  DioClient(this._ref, this._storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: APIConstants.baseUrl,
        connectTimeout: APIConstants.connectTimeout,
        receiveTimeout: APIConstants.receiveTimeout,
      ),
    );
    dio.interceptors.add(_authInterceptor());
    dio.interceptors.add(_errorInterceptor()); // Add error interceptor
    // Optional: Add logging interceptor
    // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // No need for Ref here if _storage is passed via constructor
        final token = await _storage.read(key: AppConstants.authTokenKey);
        if (token != null) {
          options.headers[APIConstants.authHeader] = 'Token $token';
        }
        return handler.next(options);
      },
    );
  }

  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException err, handler) async {
        final path = err.requestOptions.path;
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          if (!path.contains(APIConstants.login)) {
            final authStatus = _ref.read(authNotifierProvider).status;
            if (authStatus == AuthStatus.authenticated) {
              try {
                await _ref.read(authNotifierProvider.notifier).logout();
                print('[DioClient] Auto-logged out due to 401 Unauthorized.');
              } catch (e) {
                print('[DioClient] Error during auto-logout: $e');
              }
            }
          }
        }

        handler.next(err);
      },
    );
  }
}

final dioClientProvider = Provider<Dio>((ref) {
  final storage = ref.read(secureStorageProvider);
  return DioClient(ref, storage).dio;
});
