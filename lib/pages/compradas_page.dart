import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // para acessar o AppSettings e ContaRepository

import '../config/app.settings.dart'; // para acessar as configurações de local e símbolo
import '../helpers/formatters.dart'; // para formatar os valores de acordo com o local e símbolo
import '../repositories/conta_repository.dart'; // para acessar os dados da conta, como saldo e carteira

class CompradasPage extends StatelessWidget {
  const CompradasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold é a estrutura base da tela
    final conta = context.watch<
        ContaRepository>(); // para acessar os dados da conta e atualizar a tela quando eles mudarem
    final settings = context.watch<
        AppSettings>(); // para acessar as configurações de local e símbolo e atualizar a tela quando eles mudarem

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Carteira e Histórico'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Carteira'),
                Tab(text: 'Histórico'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // carteira
              conta.carteira.isEmpty
                  ? const Center(
                      child: Text('Nenhuma Moeda Comprada'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: conta.carteira.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final p = conta.carteira[i];

                        return ListTile(
                          leading: p.moeda.icone.isEmpty
                              ? const CircleAvatar(
                                  child: Icon(Icons.currency_bitcoin))
                              : Image.asset(p.moeda.icone,
                                  width: 32, height: 32),
                          title: Text('${p.moeda.nome} (${p.moeda.sigla})'),
                          subtitle: Text('Quantidade: ${p.quantidade}'),
                          trailing: Text(
                            Formatters.formatCurrency(
                                settings, p.moeda.valor * p.quantidade),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),

              // histórico
              conta.historico.isEmpty
                  ? const Center(child: Text('Sem transações registradas'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: conta.historico.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final t = conta.historico[i];
                        final data =
                            DateTime.fromMillisecondsSinceEpoch(t.dataOperacao);
                        return ListTile(
                          leading: Icon(
                            t.tipo == 'compra'
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                          ),
                          title: Text('${t.tipo} - ${t.moeda} - (${t.sigla})'),
                          subtitle: Text(
                            '${data.day.toString().padLeft(2, '0')}/'
                            '${data.month.toString().padLeft(2, '0')}/'
                            '${data.year}  '
                            '${data.hour.toString().padLeft(2, '0')}:'
                            '${data.minute.toString().padLeft(2, '0')}'
                            '\nQtd: ${t.quantidade}',
                          ),
                          trailing: Text(
                            Formatters.formatCurrency(
                                settings, t.valor * t.quantidade),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isThreeLine:
                              true, // para permitir que o subtitle ocupe mais de uma linha
                        );
                      },
                    ),
            ],
          ),
        ));
  }
}
