import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/profile/data/models/profile.dart';
import 'package:rent_me/features/profile/data/profile_repository.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  FutureOr<UserProfile> build() async {
    ref.watch(authNotifierProvider);
    return _fetchProfile();
  }

  Future<UserProfile> _fetchProfile() async {
    final repository = ref.read(userProfileRepositoryProvider);
    return await repository.fetchProfile();
  }

  Future<void> updateProfile({
    required String? phoneNum,
    required String? bio,
    required File? imageFile,
  }) async {
    final repository = ref.read(userProfileRepositoryProvider);
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateProfile(
        bio: bio,
        phoneNumber: phoneNum,
        profilePicture: imageFile,
      );
      return _fetchProfile();
    });
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
      UserProfileNotifier.new,
    );
