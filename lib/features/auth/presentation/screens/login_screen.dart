// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // For navigation after login
import 'package:rent_me/core/constants/constants.dart'; // For route paths
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/shared/widgets/custom_text_btn.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref
            .read(authNotifierProvider.notifier)
            .login(
              _usernameController.text.trim(),
              _passwordController.text.trim(),
            );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  onTapOutside:
                      (_) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onTapOutside:
                      (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitLogin,
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Login'),
                ),
                const SizedBox(height: 20),
                CustomTextBtn(
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                  onTap:
                      _isLoading
                          ? null
                          : () {
                            context.push(AppConstants.registerRoute);
                          },
                  onPressColor: Colors.indigo.shade400,
                  text: 'Don\'t have an account? Register',
                ),
                CustomTextBtn(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.underline,
                  ),
                  onTap:
                      _isLoading
                          ? null
                          : () {
                            ref
                                .read(authNotifierProvider.notifier)
                                .guestLogin();
                          },
                  onPressColor: Colors.indigo.shade400,
                  text: 'Continue without register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
