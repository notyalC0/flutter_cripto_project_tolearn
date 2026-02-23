import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AppSettings extends ChangeNotifier {
  final Box _box = Hive.box('settings');

  /// ---------------- MOEDA / LOCALE ---------------- \\\
  Map<String, String> locale = {
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  late NumberFormat real;

  /// ---------------- TEMA ---------------- \\\
  ThemeMode themeMode = ThemeMode.light;

  AppSettings() {
    _loadSettings();
  }

  void _loadSettings() {
    /// moeda \\\
    final local = _box.get('local', defaultValue: 'pt_BR');
    final name = _box.get('name', defaultValue: 'R\$');

    locale = {'locale': local, 'name': name};

    real = NumberFormat.currency(
      locale: local.replaceAll('_', '-'),
      name: name,
      decimalDigits: 2,
    );

    /// tema \\\
    final theme = _box.get('theme', defaultValue: 'light');

    if (theme == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }

    notifyListeners();
  }

  /// -------- ALTERAR MOEDA --------
  Future<void> setLocale(String local, String name) async {
    await _box.put('local', local);
    await _box.put('name', name);
    _loadSettings();
  }

  /// -------- ALTERAR TEMA --------
  Future<void> setTheme(bool isDark) async {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    await _box.put('theme', isDark ? 'dark' : 'light');

    notifyListeners();
  }

  bool get isDark => themeMode == ThemeMode.dark;
  String get symbol => locale['name']!;
  String get localeCode => locale['locale']!;
}
