import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_state.dart';
import 'package:rent_me/features/auth/presentation/screens/login_screen.dart';
import 'package:rent_me/features/auth/presentation/screens/register_screen.dart';
import 'package:rent_me/features/auth/presentation/screens/verify_screen.dart';
import 'package:rent_me/features/leases/presentation/screens/lease_detail_screen.dart';
import 'package:rent_me/features/leases/presentation/screens/lease_list_screen.dart';
import 'package:rent_me/features/leases/presentation/screens/lease_offer_screen.dart';
import 'package:rent_me/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:rent_me/features/properties/presentation/screens/property_add_screen.dart';
import 'package:rent_me/features/properties/presentation/screens/property_detail_screen.dart';

import 'package:rent_me/features/properties/presentation/screens/property_list_screen.dart';
import 'package:rent_me/features/profile/presentation/screens/profile_screen.dart';
import 'package:rent_me/shared/widgets/main_shell.dart';
import 'package:rent_me/shared/widgets/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifer = ref.watch(authNotifierProvider.notifier);
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: AppConstants.splashRoute,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authNotifer.stream),

    redirect: (BuildContext context, GoRouterState state) {
      final authStatus = ref.read(authNotifierProvider).status;
      final location = state.matchedLocation;

      if (authStatus == AuthStatus.unknown) {
        return location == AppConstants.splashRoute
            ? null
            : AppConstants.splashRoute;
      }

      if (authStatus == AuthStatus.pending) {
        return location == AppConstants.verifyRoute
            ? null
            : AppConstants.verifyRoute;
      }

      final loggedIn = authStatus == AuthStatus.authenticated;
      final isAuthRoute =
          location == AppConstants.loginRoute ||
          location == AppConstants.registerRoute;
      final isSplash = location == AppConstants.splashRoute;

      if (loggedIn) {
        if (isSplash || isAuthRoute) {
          return AppConstants.propertiesRoute;
        }
        return null;
      }

      if (!loggedIn) {
        if (isSplash || !isAuthRoute) {
          return AppConstants.loginRoute;
        }
        return null;
      }

      return null;
    },

    routes: <RouteBase>[
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.verifyRoute,
        builder: (context, state) => const VerifyScreen(),
      ),

      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: <RouteBase>[
          //Tab 0
          GoRoute(
            path: AppConstants.propertiesRoute,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: PropertyListScreen()),
            routes: <RouteBase>[
              GoRoute(
                path: 'add',
                builder: (context, state) {
                  return PropertyAddScreen();
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final propertyId = state.pathParameters['id'];
                  return PropertyDetailScreen(
                    propertyId: propertyId ?? 'default',
                  );
                },
                routes: [
                  GoRoute(
                    path: 'offer',
                    builder: (context, state) {
                      final propertyId = state.pathParameters['id'];
                      return LeaseOfferScreen(
                        propertyId: propertyId ?? 'default',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          //Tab 1
          GoRoute(
            path: AppConstants.leasesRoute,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: LeaseListScreen()),
            routes: <RouteBase>[
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final leaseId = state.pathParameters['id'];
                  return LeaseDetailScreen(id: leaseId ?? 'default');
                },
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.profileRoute,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
            routes: <RouteBase>[
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  return ProfileEditScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
