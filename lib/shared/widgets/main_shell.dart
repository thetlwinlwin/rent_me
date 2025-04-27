import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/shared/providers/bottom_nav_provider.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    void navigateToTab(int index) {
      ref.read(bottomNavIndexProvider.notifier).state = index;
      switch (index) {
        case 0:
          context.go(AppConstants.propertiesRoute);
          break;
        case 1:
          context.go(AppConstants.leasesRoute);
          break;
        case 2:
          context.go(AppConstants.profileRoute);
          break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: navigateToTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'My Leases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
