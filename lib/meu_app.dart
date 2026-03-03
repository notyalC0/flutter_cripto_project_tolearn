import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:provider/provider.dart';

import 'config/app.settings.dart';

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  static _MeuAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MeuAppState>();

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    const primaryBlue = Color(0xFF1E3A8A);
    const darkBackground = Color(0xFF0F172A);
    const darkSurface = Color(0xFF1E293B);

    ThemeData buildTheme(Brightness brightness) {
      return ThemeData(
        useMaterial3: true,
        brightness: brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: brightness,
          surface: brightness == Brightness.dark ? darkSurface : null,
        ),
        scaffoldBackgroundColor:
            brightness == Brightness.dark ? darkBackground : null,
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            isDense: true,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            fillColor: brightness == Brightness.dark
                ? darkSurface.withOpacity(0.5)
                : Colors.grey[100]),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        visualDensity: VisualDensity.standard,
      );
    }

    return MaterialApp(
      title: 'nexa',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const LoginPage(),
    );
  }
}
