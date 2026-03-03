import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // para acessar o AppSettings e ContaRepository

import '../config/app.settings.dart'; // para acessar as configurações de local e símbolo
import '../helpers/formatters.dart'; // para formatar os valores de acordo com o local e símbolo
import '../repositories/conta_repository.dart'; // para acessar os dados da conta, como saldo e carteira

class CompradasPage extends StatelessWidget {
  const CompradasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final settings = context.watch<AppSettings>();

    final theme = Theme.of(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('MINHA CARTEIRA'),
            bottom: TabBar(
              indicatorColor: theme.colorScheme.primary,
              labelColor: theme.hintColor,
              tabs: const [
                Tab(text: 'Carteira'),
                Tab(text: 'Histórico'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              conta.carteira.isEmpty
                  ? _buildEmptyState(theme, "Nenhuma moeda comprada")
                  : _buildList(
                      itemCount: conta.carteira.length,
                      itemBuilder: (context, i) {
                        final p = conta.carteira[i];

                        return ListTile(
                          leading:
                              Image.asset(p.moeda.icone, width: 32, height: 32),
                          title: Text(
                            '${p.moeda.nome} (${p.moeda.sigla})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Qtd: ${p.quantidade}'),
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
                  ? _buildEmptyState(theme, 'Sem transações registradas')
                  : _buildList(
                      itemCount: conta.historico.length,
                      itemBuilder: (context, i) {
                        final t = conta.historico[i];
                        final data =
                            DateTime.fromMillisecondsSinceEpoch(t.dataOperacao);
                        final isCompra = t.tipo == 'compra';
                        return ListTile(
                          leading: Icon(
                            isCompra
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                            color: isCompra ? Colors.teal : Colors.deepOrange,
                          ),
                          title: Text(' ${t.moeda} (${t.sigla})'),
                          subtitle: Text(
                            '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}\nTotal: ${t.quantidade}',
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            Formatters.formatCurrency(
                                settings, t.valor * t.quantidade),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ));
  }
}

Widget _buildList(
    {required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder}) {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    itemCount: itemCount,
    separatorBuilder: (_, __) =>
        const Divider(height: 1), // Divider bem fininho
    itemBuilder: itemBuilder,
  );
}

// Helper para estados vazios
Widget _buildEmptyState(ThemeData theme, String text) {
  return Center(
    child: Text(text, style: TextStyle(color: theme.hintColor)),
  );
}
