import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/carteira.dart';
import 'package:flutter_app/models/historico.dart';

import '../models/cart_item.dart';
import '../models/conta.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';
import '../models/transacao.dart';
import '../service/api_service.dart';
import 'moeda_repository.dart';

class ContaRepository extends ChangeNotifier {
  final _service = ApiService();
  int? contaID;
  double _saldo = 0;
  final List<Posicao> _carteira = [];
  final List<Transacao> _historico = [];

  double get saldo => _saldo;
  List<Posicao> get carteira => List.unmodifiable(_carteira);
  List<Transacao> get historico => List.unmodifiable(_historico);

  ContaRepository() {
    _init();
  }

  Future<void> _init() async {
    await refreshAll();
  }

  Future<void> refreshAll() async {
    await _getSaldo();
    await _getCarteira();
    await _getHistorico();
    notifyListeners();
  }

  //------------- GETTERS ---------------\\

// Busca o saldo atual da conta, se não existir, cria uma linha com saldo 0

  Future<void> _getSaldo() async {
    try {
      final conta = await _service.fetchContas();
      if (conta.isEmpty) {
        final novaConta = await _service.addConta(Conta(saldo: 0.0));
        contaID = novaConta.id;
        _saldo = 0.0;
      } else {
        contaID = conta.first.id;
        _saldo = conta.first.saldo.toDouble();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Erro: $e');
    }
  }

// Busca as transações ordenadas da mais recente para a mais antiga

  Future<void> _getCarteira() async {
    final rows = await _service.fetchCarteira();

    _carteira.clear();

    for (final row in rows) {
      final sigla = row.sigla;
      final qtd = double.tryParse(row.quantidade.toString()) ?? 0.0;

      final Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == sigla,
        orElse: () => Moeda(
            icone: '', nome: row.moeda.toString(), sigla: sigla, valor: 0.0),
      );

      _carteira.add(Posicao(moeda: moeda, quantidade: qtd));
    }

    _carteira.sort((a, b) => a.moeda.nome.compareTo(b.moeda.nome));
  }

  Future<void> _getHistorico() async {
    final rows = await _service.fetchHistorico();

    _historico
      ..clear()
      ..addAll(rows.map((row) {
        final qtdr = double.tryParse(row.qtd.toString()) ?? 0.0;
        return Transacao(
            dataOperacao: (row.dataOp).toInt(),
            tipo: row.tipoOp.toString(),
            moeda: row.moeda.toString(),
            sigla: row.sigla.toString(),
            valor: (row.valor).toDouble(),
            quantidade: qtdr);
      }));

    _historico.sort((a, b) => b.dataOperacao.compareTo(a.dataOperacao));
  }




  Future<void> checkoutCarrinho(List<CartItem> itens) async {
  if (itens.isEmpty) return;

  final lista = itens.map((i) => {
    'sigla': i.moeda.sigla,
    'quantidade': i.quantidadeMoeda,
  }).toList();

  await _service.processarCarrinho(lista);
  await refreshAll();
}


  Future<void> vendaCarrinho(List<CartItem> itens) async {
  if (itens.isEmpty) return;

  for (final item in itens) {
    await _service.vender(item.moeda.sigla, item.quantidadeMoeda);
  }

  await refreshAll();
}

Future<void> depositar(double valor) async {
    await _service.depositar(valor);
    await refreshAll();
}

  void reset() {
    _saldo = 0;
    contaID = null;
    _historico.clear();
    _carteira.clear();
    notifyListeners();
  }
}
