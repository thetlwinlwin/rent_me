import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) {
  ref.watch(authNotifierProvider);
  return 0;
});
