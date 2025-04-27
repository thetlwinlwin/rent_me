import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/core/storage/secure_storage.dart';
import 'package:rent_me/features/auth/data/auth_repository.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_state.dart';
import 'package:rent_me/shared/enums.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorage _secureStorage;

  AuthStateNotifier(this._authRepository, this._secureStorage)
    : super(const AuthState.unknown()) {
    _checkInitialAuthStatus();
  }

  Future<void> _checkInitialAuthStatus() async {
    try {
      final token = await _secureStorage.read(key: AppConstants.authTokenKey);
      final emailStatus = await _secureStorage.read(
        key: AppConstants.emailStatus,
      );
      if (token != null) {
        try {
          final user = await _authRepository.getCurrentUser();
          state = AuthState(
            status: AuthStatus.authenticated,
            user: user,
            token: token,
          );
        } catch (e) {
          await _secureStorage.delete(key: AppConstants.authTokenKey);
          state = const AuthState.unauthenticated();
        }
      } else if (emailStatus != null) {
        state = const AuthState(status: AuthStatus.pending);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> verify(String key) async {
    try {
      await _authRepository.verifyEmail(key: key);
      state = AuthState.unauthenticated();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String emailOrUsername, String password) async {
    try {
      final token = await _authRepository.login(emailOrUsername, password);
      final user = await _authRepository.getCurrentUser();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        forceUserNull: true,
        forceTokenNull: true,
      );
      rethrow;
    }
  }

  Future<void> guestLogin() async {
    state = AuthState.guest();
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      rethrow;
    } finally {
      state = const AuthState.unauthenticated();
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
      await _authRepository.register(
        email: email,
        password1: password1,
        password2: password2,
        username: username,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );
      state = const AuthState(status: AuthStatus.pending);
    } catch (e) {
      rethrow;
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthStateNotifier, AuthState>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      final secureStorage = ref.watch(secureStorageProvider);
      return AuthStateNotifier(authRepository, secureStorage);
    });
