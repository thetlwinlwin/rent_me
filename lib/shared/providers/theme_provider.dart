import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/core/storage/secure_storage.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  () => ThemeNotifier(),
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final storage = ref.read(secureStorageProvider);
    final saved = await storage.read(key: AppConstants.themeModeKey);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else if (saved == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: AppConstants.themeModeKey, value: mode.name);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
