import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/favoritas.dart';
import 'package:flutter_app/service/conta_service.dart';
import 'package:flutter_app/models/moeda.dart';
import 'moeda_repository.dart';

class FavoritasRepository extends ChangeNotifier {
  final _service = ContaService();
  final List<Moeda> _lista = [];
  bool _isLoading = false;

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  FavoritasRepository() {
    load();
  }

  Future<void> load() async {
    if (_isLoading) return;
    try {
      _isLoading = true;

      final favoritas = await _service.fetchFavoritas();
      final siglas = favoritas.map((f) => f.sigla).toSet().toList();

      _lista.clear();
      _lista.addAll(
          MoedaRepository.tabela.where((m) => siglas.contains(m.sigla)));

      notifyListeners();
    } catch (e) {
      debugPrint('Nao foi possivel obter as favoritas: $e');
    } finally {
      _isLoading = false;
    }
  }

  bool isFavorita(Moeda moeda) => _lista.any((m) => m.sigla == moeda.sigla);

  Future<void> saveAll(List<Moeda> moedas) async {
    for (final moeda in moedas) {
      if (!isFavorita(moeda)) {
        try {
          await _service.addFavoritas(Favoritas(
            sigla: moeda.sigla,
            nome: moeda.nome,
            icone: moeda.icone,
            valor: moeda.valor,
          ));
          _lista.add(moeda);
        } catch (e) {
          print('Erro ao atualizar favoritas $e');
        }
      }
    }
    notifyListeners();
  }

  Future<void> remove(Moeda moeda) async {
    try {
      await _service.deletarFavoritas(moeda.sigla);
      _lista.removeWhere((m) => m.sigla == moeda.sigla);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar favoritas erro: $e');
    }
  }

  Future<void> clear() async {
    for (final moeda in List.of(_lista)) {
      try {
        await _service.deletarFavoritas(moeda.sigla);
      } catch (e) {
        print('falha ao limpar moeda favorita ${moeda.sigla} erro: $e');
      }
    }
    _lista.clear();

    notifyListeners();
  }
}
