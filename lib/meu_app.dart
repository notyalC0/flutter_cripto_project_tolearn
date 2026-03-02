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

    return MaterialApp(
      title: 'nexa',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.transparent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: ColorScheme.fromSeed(
            seedColor: primaryBlue,
            brightness: Brightness.dark,
            surface: darkSurface),
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blueGrey.shade800)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryBlue, width: 2)),
            filled: true,
            fillColor: Colors.transparent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
