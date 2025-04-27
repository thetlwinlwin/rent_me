import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_state.dart';

class RouteGuard extends ConsumerWidget {
  final Widget child;
  const RouteGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authNotifierProvider).status;
    final isAuth = status == AuthStatus.authenticated;
    return isAuth
        ? child
        : Center(
          child: TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
            child: Text(
              'login to continue',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
  }
}
