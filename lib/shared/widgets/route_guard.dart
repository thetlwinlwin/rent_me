import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_state.dart';
import 'package:rent_me/shared/widgets/custom_text_btn.dart';

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
          child: CustomTextBtn(
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.grey.shade500,
              decoration: TextDecoration.underline,
            ),
            onTap: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
            onPressColor: Colors.indigo.shade400,
            text: 'login to continue',
          ),
        );
  }
}
