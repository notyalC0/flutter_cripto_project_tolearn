import 'package:flutter/material.dart';
import 'package:flutter_app/config/app.settings.dart';
import 'package:flutter_app/repositories/cart_repository.dart';
import 'package:flutter_app/repositories/conta_repository.dart';
import 'package:flutter_app/repositories/favoritas_repository.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'meu_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('favorites');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => ContaRepository()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
        ChangeNotifierProvider(create: (context) => CartRepository()),
      ],
      child: const MeuApp(),
    ),
  );
}
