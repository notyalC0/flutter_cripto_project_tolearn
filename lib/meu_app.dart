import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
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

    return MaterialApp(
      title: 'nexa',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
