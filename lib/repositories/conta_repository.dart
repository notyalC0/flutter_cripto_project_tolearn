import 'package:flutter/material.dart';
import 'package:flutter_app/database/db.dart';
import 'package:flutter_app/models/carteira.dart';
import 'package:flutter_app/models/historico.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:collection/collection.dart';
import '../models/cart_item.dart';
import '../models/conta.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';
import '../models/transacao.dart';
import '../service/conta_service.dart';
import 'moeda_repository.dart';

class ContaRepository extends ChangeNotifier {
  final _service = ContaService();
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

  Future<void> _init() async => await refreshAll();

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
        await _service.addConta(Conta(saldo: 0.0));
      }
      contaID = conta.first.id;
      _saldo = (conta.first.saldo).toDouble();
      notifyListeners();
    } catch (e) {
      print('Erro: $e');
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

//------------- SETTERS ---------------\\

  Future<void> setSaldo(double valor) async {
    final contaNova = Conta(id: contaID!, saldo: valor);
    await _service.updateConta(contaNova);

    _saldo = valor;
    notifyListeners();
  }

  Future<void> checkoutCarrinho(List<CartItem> itens) async {
    if (itens.isEmpty)
      return; // verificar se o carrinho não está vazio se for vazio, não faz nada

    final total = itens.fold(
        0.0, (s, i) => s + i.valorReais); // calcular o valor total do carrinho
    if (_saldo < total) throw Exception("Saldo insuficiente");
    final saldoN = _saldo - total;

    // obter o timestamp atual para registrar a data da transação
    final now = DateTime.now().millisecondsSinceEpoch;

    // atualizar o saldo da conta no banco de dados
    await _service.updateConta(Conta(id: contaID!, saldo: saldoN));

    for (final item in itens) {
      final sigla = item.moeda.sigla;
      final nome = item.moeda.nome;
      final qtdCripto = item.quantidadeMoeda;
      final valorReais = item.moeda.valor;

      final posicaoAtual =
          _carteira.where((p) => p.moeda.sigla == sigla).firstOrNull;

      if (posicaoAtual == null) {
        await _service.addCarteira(Carteira(
          sigla: sigla,
          moeda: nome,
          quantidade: qtdCripto.toString(),
        ));
      } else {
        final quantidadeNova = posicaoAtual.quantidade + qtdCripto;
        await _service.updateCarteira(Carteira(
          sigla: sigla,
          moeda: nome,
          quantidade: quantidadeNova.toString(),
        ));
      }

      await _service.addHistorico(Historico(
        dataOp: now,
        tipoOp: "compra",
        moeda: nome,
        sigla: sigla,
        valor: valorReais,
        qtd: qtdCripto,
      ));
    }

    await refreshAll(); // atualizar os dados da conta após a compra
  }
}
