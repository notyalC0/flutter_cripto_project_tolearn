import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import '../repositories/conta_repository.dart';
import '../models/cart_item.dart';
import '../repositories/cart_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/helpers/formatters.dart';
import 'package:flutter_app/models/moeda.dart';
import 'package:provider/provider.dart';

import '../config/app.settings.dart';

class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;

  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  late CurrencyTextInputFormatter _currencyFormatter;
  String _lastLocale = '';
  String _lastSymbol = '';
  double quantidade = 0;

  void adicionarAoCarrinho() {
    if (_form.currentState!.validate()) {
      final valorDigitado = Formatters.moedaToDouble(_currencyFormatter);

      context.read<CartRepository>().setValor(widget.moeda, valorDigitado);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicionado ao carrinho!')),
      );
    }
  }

  Future<void> comprarAgora() async {
    if (_form.currentState!.validate()) {
      final valorDigitado = Formatters.moedaToDouble(_currencyFormatter);
      try {
        await context.read<ContaRepository>().checkoutCarrinho(
            [CartItem(moeda: widget.moeda, valorReais: valorDigitado)]);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final String local = settings.localeCode;
    final String symbol = settings.symbol;

    if (_lastLocale != local || _lastSymbol != symbol) {
      _lastLocale = local;
      _lastSymbol = symbol;

      _currencyFormatter = CurrencyTextInputFormatter(
        locale: local,
        symbol: symbol,
        decimalDigits: 2,
      );
    }

    return Scaffold(
      // backgroundColor pega a cor do tema atual (claro ou escuro)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // iconTheme garante que o botão de voltar use a cor do tema
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          widget.moeda.nome,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card de informações da moeda ──────────────────────────────
            Card(
              // elevation controla a sombra do card
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Ícone da moeda
                    Image.asset(widget.moeda.icone, width: 48, height: 48),
                    const SizedBox(width: 16),

                    // Nome e sigla
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.moeda.nome,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.moeda.sigla,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Valor atual
                    Text(
                      Formatters.moeda(settings, widget.moeda.valor),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Quantidade calculada ──────────────────────────────────────
            // AnimatedOpacity faz a quantidade aparecer/sumir suavemente
            AnimatedOpacity(
              opacity: quantidade > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '≈ $quantidade ${widget.moeda.sigla}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Campo de valor ────────────────────────────────────────────
            Form(
              key: _form,
              child: TextFormField(
                controller: _valor,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Valor em $symbol',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  // enabledBorder é a borda quando o campo não está focado
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  filled: true,
                  // fillColor pega a cor de fundo do tema
                  fillColor: Theme.of(context).cardColor,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  _currencyFormatter,
                ],
                validator: (value) {
                  final valorDigitado =
                      Formatters.moedaToDouble(_currencyFormatter);

                  if (value == null || value.isEmpty || valorDigitado == 0) {
                    return 'Informe um valor!';
                  }

                  if (valorDigitado < 1) {
                    return 'Valor mínimo é ${settings.real.format(1)}';
                  }

                  return null;
                },
                onChanged: (_) {
                  setState(() {
                    final valorDigitado =
                        Formatters.moedaToDouble(_currencyFormatter);
                    quantidade = valorDigitado == 0
                        ? 0
                        : valorDigitado / widget.moeda.valor;
                  });
                },
              ),
            ),

            // Spacer empurra o botão para o fundo da tela
            const Spacer(),

            // ── Botão comprar ─────────────────────────────────────────────
            Column(
              children: [
                SizedBox(
                  width: double.infinity, // botão ocupa toda a largura
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: adicionarAoCarrinho,
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: const Text(
                      'adicionar ao carrinho',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, // botão ocupa toda a largura
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: comprarAgora,
                    icon: const Icon(Icons.flash_on),
                    label: const Text(
                      'comprar Agora',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24), // respiro no fundo
          ],
        ),
      ),
    );
  }
}
