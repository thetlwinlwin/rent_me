import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/profile/presentation/providers/profile_provider.dart';
import 'package:rent_me/shared/providers/bottom_nav_provider.dart';
import 'package:rent_me/shared/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon:
                theme == ThemeMode.light
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(bottomNavIndexProvider.notifier).state = 0;
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),

      body: profileAsync.when(
        skipLoadingOnRefresh: true,
        data:
            (profile) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator.adaptive(
                onRefresh: () => ref.refresh(userProfileProvider.future),
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              profile.profile.profilePicture != null
                                  ? NetworkImage(
                                    profile.profile.profilePicture!,
                                  )
                                  : null,
                          child:
                              profile.profile.profilePicture == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        context.go(AppConstants.profileEditRoute);
                      },
                      child: const Text('Edit Profile'),
                    ),
                    ListTile(
                      title: Text(profile.username),
                      subtitle: const Text('Username'),
                    ),
                    ListTile(
                      title: Text(profile.email),
                      subtitle: const Text('Email'),
                    ),
                    ListTile(
                      title: Text(profile.profile.phoneNumber ?? '-'),
                      subtitle: const Text('Phone Number'),
                    ),
                    ListTile(
                      title: Text(profile.profile.bio ?? '-'),
                      subtitle: const Text('Bio'),
                    ),
                    ListTile(
                      title: Text(profile.profile.role.displayName),
                      subtitle: const Text('Role'),
                    ),
                    if (profile.profile.isVerifiedLandlord)
                      const ListTile(
                        leading: Icon(Icons.verified, color: Colors.green),
                        title: Text('Verified Landlord'),
                      ),
                  ],
                ),
              ),
            ),
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Error loading leases: $error')],
                ),
              ),
            ),
      ),
    );
  }
}
