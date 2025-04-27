import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_state.dart';

class ProtectedButton extends ConsumerWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  const ProtectedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: !isAuthenticated ? null : onPressed,
          style: style,
          child: child,
        ),
        if (!isAuthenticated)
          TextButton(
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
      ],
    );
  }
}
