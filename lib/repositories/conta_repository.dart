import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/conta.dart';
import '../models/carteira.dart';
import '../models/historico.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';
import '../models/transacao.dart';
import '../service/conta_service.dart';
import 'moeda_repository.dart';

class ContaRepository extends ChangeNotifier {
  final _service = ContaService();
  int? _contaId;
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

  Future<void> _getSaldo() async {
    final contas = await _service.fetchContas();
    if (contas.isNotEmpty) {
      _contaId = contas.first.id;
      _saldo = contas.first.saldo;
    }
  }

  Future<void> _getCarteira() async {
    final lista = await _service.fetchCarteira();
    _carteira.clear();
    for (final c in lista) {
      final Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == c.sigla,
        orElse: () => Moeda(
          icone: '',
          nome: c.moeda,
          sigla: c.sigla,
          valor: 0.0,
        ),
      );
      _carteira.add(Posicao(
        moeda: moeda,
        quantidade: double.tryParse(c.quantidade) ?? 0.0,
      ));
    }
    _carteira.sort((a, b) => a.moeda.nome.compareTo(b.moeda.nome));
  }

  Future<void> _getHistorico() async {
    final lista = await _service.fetchHistorico();
    _historico.clear();
    _historico.addAll(lista.map((h) => Transacao(
          dataOperacao: h.data_operacao,
          tipo: h.tipo_operacao,
          moeda: h.moeda,
          sigla: h.sigla,
          valor: h.valor,
          quantidade: h.quantidade,
        )));
  }

  Future<void> setSaldo(double valor) async {
    final contaAtualizada = Conta(id: _contaId!, saldo: valor);
    await _service.updateConta(contaAtualizada);
    _saldo = valor;
    notifyListeners();
  }

  Future<void> checkoutCarrinho(List<CartItem> itens) async {
    if (itens.isEmpty) return;

    final total = itens.fold(0.0, (s, i) => s + i.valorReais);
    if (_saldo < total) throw Exception('Saldo insuficiente');

    final now = DateTime.now().millisecondsSinceEpoch;
    final novoSaldo = _saldo - total;

    await _service.updateConta(Conta(id: _contaId!, saldo: novoSaldo));

    for (final item in itens) {
      final sigla = item.moeda.sigla;
      final nome = item.moeda.nome;
      final qtdCripto = item.quantidadeMoeda;
      final valorUnitario = item.moeda.valor;

      final posicaoAtual =
          _carteira.where((p) => p.moeda.sigla == sigla).firstOrNull;

      if (posicaoAtual == null) {
        await _service.addCarteira(Carteira(
          sigla: sigla,
          moeda: nome,
          quantidade: qtdCripto.toString(),
        ));
      } else {
        final novaQtd = posicaoAtual.quantidade + qtdCripto;
        await _service.updateCarteira(Carteira(
          sigla: sigla,
          moeda: nome,
          quantidade: novaQtd.toString(),
        ));
      }

      await _service.addHistorico(Historico(
        id: 0,
        data_operacao: now,
        tipo_operacao: 'compra',
        moeda: nome,
        sigla: sigla,
        valor: valorUnitario,
        quantidade: qtdCripto,
      ));
    }

    await refreshAll();
  }
}
