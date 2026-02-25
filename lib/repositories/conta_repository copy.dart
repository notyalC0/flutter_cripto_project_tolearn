import 'package:flutter/material.dart';
import 'package:flutter_app/database/db.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../models/cart_item.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';
import '../models/transacao.dart';
import 'moeda_repository.dart';

class ContaRepository extends ChangeNotifier {
  Database? _db;
  double _saldo = 0;
  final List<Posicao> _carteira = [];
  final List<Transacao> _historico = [];

  double get saldo => _saldo;
  List<Posicao> get carteira => List.unmodifiable(_carteira);
  List<Transacao> get historico => List.unmodifiable(_historico);

  ContaRepository() {
    _init();
  }

  Future<Database> getDb() async => _db ?? await DB.instance.database;

  Future<void> _init() async {
    _db = await DB.instance.database;
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
    final db = await getDb();
    final conta = await db.query('conta', limit: 1);

    if (conta.isEmpty) {
      // se não existir linha, cria uma
      await db.insert('conta', {'saldo': 0.0});
      _saldo = 0.0;
      return;
    }
    _saldo = (conta.first['saldo'] as num).toDouble();
    notifyListeners();
  }

// Busca as transações ordenadas da mais recente para a mais antiga

  Future<void> _getCarteira() async {
    final db = await getDb();
    final rows = await db.query('carteira');

    _carteira.clear();

    for (final row in rows) {
      final sigla = row['sigla'] as String;
      final qtd = double.tryParse(row['quantidade'].toString()) ?? 0.0;

      final Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == sigla,
        orElse: () => Moeda(
            icone: '', nome: row['moeda'].toString(), sigla: sigla, valor: 0.0),
      );

      _carteira.add(Posicao(moeda: moeda, quantidade: qtd));
    }

    _carteira.sort((a, b) => a.moeda.nome.compareTo(b.moeda.nome));
  }

  Future<void> _getHistorico() async {
    final db = await getDb();
    final rows = await db.query('historico', orderBy: 'data_operacao DESC');

    _historico
      ..clear()
      ..addAll(rows.map((row) {
        final qtd = double.tryParse(row['quantidade'].toString()) ?? 0.0;
        return Transacao(
            dataOperacao: (row['data_operacao'] as num).toInt(),
            tipo: row['tipo_operacao'].toString(),
            moeda: row['moeda'].toString(),
            sigla: row['sigla'].toString(),
            valor: (row['valor'] as num).toDouble(),
            quantidade: qtd);
      }));
  }

//------------- SETTERS ---------------\\

  Future<void> setSaldo(double valor) async {
    final db = await getDb();

    // garante que existe uma linha (id = 1)
    final conta = await db.query('conta', limit: 1);
    if (conta.isEmpty) {
      await db.insert('conta', {'saldo': valor});
    } else {
      await db.update(
        'conta',
        {'saldo': valor},
        where: 'id = ?',
        whereArgs: [conta.first['id']],
      );
    }

    _saldo = valor;
    notifyListeners();
  }

  Future<void> checkoutCarrinho(List<CartItem> itens) async {
    if (itens.isEmpty) return; // verificar se o carrinho não está vazio se for vazio, não faz nada

    final db = await getDb(); // obter a instância do banco de dados
    final total = itens.fold(
        0.0, (s, i) => s + i.valorReais); // calcular o valor total do carrinho

    final contaRow = await db.query('conta',
        limit: 1); // buscar a conta para verificar o saldo atual
    final saldoDb = (contaRow.first['saldo'] as num)
        .toDouble(); // obter o saldo atual da conta

    if (saldoDb < total) {
      // verificar se o saldo é suficiente para a compra
      throw Exception(
          'Saldo insuficiente'); // lançar uma exceção se o saldo for insuficiente
    }

    await db.transaction((txn) async {
      final novoSaldo = saldoDb - total; // calcular o novo saldo após a compra
      await txn.update(
        'conta',
        {'saldo': novoSaldo},
        where: 'id = ?',
        whereArgs: [contaRow.first['id']],
      ); // atualizar o saldo da conta no banco de dados

      final now = DateTime.now()
          .millisecondsSinceEpoch; // obter o timestamp atual para registrar a data da transação

      for (final item in itens) {
        // iterar sobre os itens do carrinho para registrar cada compra
        final sigla = item.moeda
            .sigla; // obter a sigla da moeda para identificar a posição na carteira
        final nome = item.moeda.nome; // obter o nome da moeda para registrar

        final qtdCripto = item
            .quantidadeMoeda; // calcular a quantidade de criptomoeda comprada com base no valor em reais e no valor da moeda
        final valorReais = item.moeda
            .valor; // obter o valor da moeda para calcular a quantidade comprada

        final carteiraRow = await txn.query(
          // verificar se já existe uma posição para essa moeda na carteira
          'carteira', // tabela da carteira
          where: 'sigla = ?', // condição para buscar pela sigla da moeda
          whereArgs: [sigla], // argumentos para a condição (sigla da moeda)
          limit:
              1, // limitar a busca a 1 resultado, pois só pode existir uma posição por moeda
        );

        if (carteiraRow.isEmpty) {
          // se não existir posição para essa moeda, criar uma nova entrada na carteira
          await txn.insert('carteira', {
            // inserir nova posição na carteira
            'sigla': sigla, // sigla da moeda para identificar a posição
            'moeda': nome, // nome da moeda para exibir na carteira
            'quantidade': qtdCripto
                .toString(), // quantidade comprada convertida para string para armazenar no banco de dados
          });
        } else {
          // se já existir posição para essa moeda, atualizar a quantidade somando a nova compra com a quantidade atual
          final atual =
              double.tryParse(carteiraRow.first['quantidade'].toString()) ??
                  0.0;
          // obter a quantidade atual da moeda na carteira, convertendo de string para double, e tratando o caso de valor inválido com 0.0
          final nova = atual + qtdCripto;
          // calcular a nova quantidade somando a quantidade atual com a quantidade comprada

          await txn.update(
            // atualizar a quantidade da moeda na carteira com a nova quantidade calculada
            'carteira',
            // tabela da carteira
            {'quantidade': nova.toString()},
            // nova quantidade convertida para string para armazenar no banco de dados
            where: 'sigla = ?',
            // condição para buscar pela sigla da moeda
            whereArgs: [sigla],
            // argumentos para a condição (sigla da moeda)
          );
        }

        await txn.insert('historico', {
          // registrar a transação no histórico de operações
          'data_operacao': now,
          // data da operação em timestamp para ordenar o histórico
          'tipo_operacao': 'compra',
          // tipo da operação (compra ou venda) para exibir no histórico
          'moeda': nome,
          // nome da moeda para exibir no histórico
          'sigla': sigla,
          // sigla da moeda para identificar a transação no histórico
          'valor': valorReais,
          // valor da moeda no momento da compra para registrar o preço pago
          'quantidade': qtdCripto.toString(),
          // quantidade comprada convertida para string para armazenar no banco de dados e exibir no histórico
        });
      }

      _saldo = novoSaldo;
      // atualizar o saldo localmente para refletir a compra sem precisar recarregar do banco de dados
    });

    await refreshAll(); // atualizar os dados da conta após a compra
  }
}
