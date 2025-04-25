import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/shared/enums.dart';

final isLandLordProvider = Provider<bool>((ref) {
  final role = ref.watch(
    authNotifierProvider.select((value) => value.user?.profile?.role),
  );
  return role != null && role == UserRole.landlord;
});
