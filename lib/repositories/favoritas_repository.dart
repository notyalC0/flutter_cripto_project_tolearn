import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_app/models/moeda.dart';
import 'moeda_repository.dart';

class FavoritasRepository extends ChangeNotifier {
  final Box _box = Hive.box('favorites');

  final List<Moeda> _lista = [];

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  FavoritasRepository() {
    _load();
  }

  void _load() {
    final siglas = (_box.get('siglas', defaultValue: <String>[]) as List)
        .map((e) => e.toString())
        .toList();

    _lista
      ..clear()
      ..addAll(MoedaRepository.tabela.where((m) => siglas.contains(m.sigla)));

    notifyListeners();
  }

  Future<void> _save() async {
    final siglas = _lista.map((m) => m.sigla).toList();
    await _box.put('siglas', siglas);
  }

  bool isFavorita(Moeda moeda) => _lista.any((m) => m.sigla == moeda.sigla);

  Future<void> saveAll(List<Moeda> moedas) async {
    for (final moeda in moedas) {
      if (!isFavorita(moeda)) _lista.add(moeda);
    }
    await _save();
    notifyListeners();
  }

  Future<void> remove(Moeda moeda) async {
    _lista.removeWhere((m) => m.sigla == moeda.sigla);
    await _save();
    notifyListeners();
  }

  Future<void> clear() async {
    _lista.clear();
    await _save();
    notifyListeners();
  }
}
