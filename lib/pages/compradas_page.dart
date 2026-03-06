import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vendas_detalhes_page.dart';
import 'package:provider/provider.dart';
import '../config/app.settings.dart';
import '../helpers/formatters.dart';
import '../repositories/conta_repository.dart';

// Adicionamos 'valor' e renomeamos para ser mais genérico
enum Ordem { data, tipo, moeda, valor }

class CompradasPage extends StatefulWidget {
  const CompradasPage({Key? key}) : super(key: key);

  @override
  State<CompradasPage> createState() => _CompradasPageState();
}

class _CompradasPageState extends State<CompradasPage> {
  // Estados de ordenação independentes para cada aba
  Ordem _ordemCarteira = Ordem.valor;
  Ordem _ordemHistorico = Ordem.data;

  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final settings = context.watch<AppSettings>();
    final theme = Theme.of(context);

    // 1. Lógica de Ordenação da CARTEIRA
    final carteira = [...conta.carteira];
    switch (_ordemCarteira) {
      case Ordem.valor:
        // Ordena pelo valor total investido (preço atual * quantidade)
        carteira.sort((a, b) => (b.moeda.valor * b.quantidade).compareTo(a.moeda.valor * a.quantidade));
        break;
      case Ordem.moeda:
        carteira.sort((a, b) => a.moeda.nome.compareTo(b.moeda.nome));
        break;
      default:
        break;
    }

    // 2. Lógica de Ordenação do HISTÓRICO
    final historico = [...conta.historico];
    switch (_ordemHistorico) {
      case Ordem.data:
        historico.sort((a, b) => b.dataOperacao.compareTo(a.dataOperacao));
        break;
      case Ordem.tipo:
        historico.sort((a, b) => a.tipo.compareTo(b.tipo));
        break;
      case Ordem.moeda:
        historico.sort((a, b) => a.moeda.compareTo(b.moeda));
        break;
      case Ordem.valor:
        // Ordena pelo valor total da transação na época
        historico.sort((a, b) => (b.valor * b.quantidade).compareTo(a.valor * a.quantidade));
        break;
    }

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
            // ── ABA CARTEIRA ──────────────────────────────────────────────
            conta.carteira.isEmpty
                ? _buildEmptyState(theme, "Nenhuma moeda comprada")
                : Column(
                    children: [
                      _buildBarraFiltro([
                        _buildBotaoFiltro('Valor', Ordem.valor, true, theme),
                        _buildBotaoFiltro('Moeda', Ordem.moeda, true, theme),
                      ], theme),
                      Expanded(
                        child: _buildList(
                          itemCount: carteira.length,
                          itemBuilder: (context, i) {
                            final p = carteira[i];
                            return ListTile(
                              leading: Image.asset(p.moeda.icone, width: 32, height: 32),
                              title: Text(
                                '${p.moeda.nome} (${p.moeda.sigla})',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text('Qtd: ${p.quantidade}'),
                              trailing: Text(
                                Formatters.formatCurrency(settings, p.moeda.valor * p.quantidade),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VendaDetalhesPage(
                                    moeda: p.moeda,
                                    quantidadeDisponivel: p.quantidade,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

            // ── ABA HISTÓRICO ─────────────────────────────────────────────
            conta.historico.isEmpty
                ? _buildEmptyState(theme, 'Sem transações registradas')
                : Column(
                    children: [
                      _buildBarraFiltro([
                        _buildBotaoFiltro('Data', Ordem.data, false, theme),
                        _buildBotaoFiltro('Tipo', Ordem.tipo, false, theme),
                        _buildBotaoFiltro('Moeda', Ordem.moeda, false, theme),
                        _buildBotaoFiltro('Valor', Ordem.valor, false, theme),
                      ], theme),
                      Expanded(
                        child: _buildList(
                          itemCount: historico.length,
                          itemBuilder: (context, i) {
                            final t = historico[i];
                            final data = DateTime.fromMillisecondsSinceEpoch(t.dataOperacao);
                            final isCompra = t.tipo == 'compra';
                            return ListTile(
                              leading: Icon(
                                isCompra ? Icons.add_circle_outline : Icons.remove_circle_outline,
                                color: isCompra ? Colors.teal : Colors.deepOrange,
                              ),
                              title: Text('${t.moeda} (${t.sigla})'),
                              subtitle: Text(
                                '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}\nTotal: ${t.quantidade}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              isThreeLine: true,
                              trailing: Text(
                                Formatters.formatCurrency(settings, t.valor * t.quantidade),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // Componente de barra de filtros para evitar repetição de código
  Widget _buildBarraFiltro(List<Widget> filtros, ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text('Ordenar por:', style: theme.textTheme.bodySmall),
              const SizedBox(width: 8),
              ...filtros.expand((f) => [f, const SizedBox(width: 6)]).toList(),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  // Componente de botão de filtro
  Widget _buildBotaoFiltro(String label, Ordem ordem, bool isCarteira, ThemeData theme) {
    final selecionado = isCarteira ? _ordemCarteira == ordem : _ordemHistorico == ordem;

    return GestureDetector(
      onTap: () => setState(() {
        if (isCarteira) {
          _ordemCarteira = ordem;
        } else {
          _ordemHistorico = ordem;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selecionado
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selecionado ? Colors.white : theme.hintColor,
          ),
        ),
      ),
    );
  }
}

// Funções auxiliares mantidas como no original
Widget _buildList({required int itemCount, required Widget Function(BuildContext, int) itemBuilder}) {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    itemCount: itemCount,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: itemBuilder,
  );
}

Widget _buildEmptyState(ThemeData theme, String text) {
  return Center(child: Text(text, style: TextStyle(color: theme.hintColor)));
}
