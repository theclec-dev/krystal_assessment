import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemePrefKey = 'theme_mode';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kThemePrefKey);
    if (stored == null) {
      state = ThemeMode.system;
      return;
    }
    switch (stored) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePrefKey, _modeToString(mode));
  }

  Future<void> toggleNext() async {
    final next = _nextMode(state);
    await setTheme(next);
  }

  String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _nextMode(ThemeMode current) {
    // cycle: system -> dark -> light -> system
    if (current == ThemeMode.system) return ThemeMode.dark;
    if (current == ThemeMode.dark) return ThemeMode.light;
    return ThemeMode.system;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
