import 'package:flutter/material.dart';
import 'package:flutter_app/models/moeda.dart';
import 'package:flutter_app/repositories/favoritas_repository.dart';
import 'package:flutter_app/repositories/moeda_repository.dart';
import 'package:flutter_app/widgets/moedas_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/widgets/carrinho_sheet.dart';
import '../config/app.settings.dart';
import '../repositories/cart_repository.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({Key? key}) : super(key: key);

  @override
  _MoedasPageState createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;

  void _toggleTheme() {
    final settings = context.read<AppSettings>();
    settings.setTheme(!settings.isDark);
  }

  @override
  Widget build(BuildContext context) {
    // existe duas formas de chamar o provider
    /* favoritas = Provider.of<FavoritasRepository>(context); */ // primeira forma
    favoritas = context.watch<FavoritasRepository>(); // segunda forma
    final settings = context.watch<AppSettings>();
    final cart = context.watch<CartRepository>();
    void abrirCarrinho(BuildContext context) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          builder: (context) => const CarrinhoSheet());
    }

    appBarDinamica() {
      final theme = Theme.of(context);

      if (selecionadas.isEmpty) {
        return AppBar(
          title: const Text('CRIPTO MOEDAS'),
          actions: [
            IconButton(
              icon: Text(
                settings.symbol,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              tooltip: 'Configurações de Moeda',
              onPressed: () {
                if (settings.localeCode == 'pt-BR') {
                  context.read<AppSettings>().setLocale('en-US', '\$');
                } else {
                  context.read<AppSettings>().setLocale('pt-BR', 'R\$');
                }
              },
            ),

            // Botão para alternar tema
            IconButton(
              onPressed: _toggleTheme,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  settings.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  key: ValueKey<bool>(settings
                      .isDark), // Importante para o Flutter saber que mudou!
                ),
              ),
            ),
          ],
        );
      } else {
        return AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => selecionadas.clear()),
          ),
          title: Text('${selecionadas.length} selecionadas'),
          backgroundColor: theme.colorScheme.primaryContainer,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        );
      }
    }

    return Scaffold(
      appBar: appBarDinamica(),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        // Define a estrutura da grade
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // número de colunas
          crossAxisSpacing: 12, // espaço horizontal entre cards
          mainAxisSpacing: 12, // espaço vertical entre cards
          childAspectRatio:
              0.90, // proporção largura/altura de cada card (1 = quadrado)
        ),

        itemCount: tabela.length,
        itemBuilder: (context, index) {
          // Card é um widget com sombra e bordas arredondadas
          return MoedasCard(
            moeda: tabela[index],
            tagPrefix: 'lista_',
            onLongPress: () {
              setState(() {
                selecionadas.contains(tabela[index])
                    ? selecionadas.remove(tabela[index])
                    : selecionadas.add(tabela[index]);
              });
            },
            selecionada: selecionadas.contains(
              tabela[index],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cart.items.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'cart',
              onPressed: () => abrirCarrinho(context),
              icon: const Icon(Icons.shopping_cart),
              label: Text('Carrinho (${cart.items.length})'),
            ),
          const SizedBox(height: 10),
          if (selecionadas.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'fav',
              onPressed: () async {
                await favoritas.saveAll(selecionadas);
                setState(() => selecionadas.clear());
              },
              label: const Text(
                'Favoritar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(
                Icons.star,
              ),
            ),
        ],
      ),
    );
  }
}
