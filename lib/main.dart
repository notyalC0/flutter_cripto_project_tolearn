import 'package:flutter/material.dart';
import 'package:flutter_app/config/app.settings.dart';
import 'package:flutter_app/repositories/cart_repository.dart';
import 'package:flutter_app/repositories/conta_repository.dart';
import 'package:flutter_app/repositories/favoritas_repository.dart';
import 'package:flutter_app/repositories/moeda_repository.dart';
import 'package:flutter_app/service/auth_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'meu_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final moedaRepo = MoedaRepository();
  await moedaRepo.carregarMoedas();

  await Hive.initFlutter();
  await Hive.openBox('settings');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => ContaRepository()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
        ChangeNotifierProvider(create: (context) => CartRepository()),
        Provider(create: (context) => AuthService()),
      ],
      child: const MeuApp(),
    ),
  );
}
