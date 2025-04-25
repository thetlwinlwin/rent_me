import 'package:flutter/foundation.dart' show immutable;
import 'package:rent_me/features/profile/data/models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, pending }

@immutable
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? token;

  const AuthState({required this.status, this.user, this.token});

  const AuthState.unknown()
    : status = AuthStatus.unknown,
      user = null,
      token = null;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? token,
    bool forceUserNull = false,
    bool forceTokenNull = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: forceUserNull ? null : (user ?? this.user),
      token: forceTokenNull ? null : (token ?? this.token),
    );
  }
}
