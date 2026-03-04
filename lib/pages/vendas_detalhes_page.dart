import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import '../repositories/conta_repository.dart';
import '../models/cart_item.dart';
import 'package:flutter_app/helpers/formatters.dart';
import 'package:flutter_app/models/moeda.dart';
import 'package:provider/provider.dart';
import '../config/app.settings.dart';

class VendaDetalhesPage extends StatefulWidget {
  final Moeda moeda;
  final double quantidadeDisponivel;

  const VendaDetalhesPage({
    Key? key,
    required this.moeda,
    required this.quantidadeDisponivel,
  }) : super(key: key);

  @override
  _VendaDetalhesPageState createState() => _VendaDetalhesPageState();
}

class _VendaDetalhesPageState extends State<VendaDetalhesPage> {
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  late CurrencyTextInputFormatter _currencyFormatter;
  String _lastLocale = '';
  String _lastSymbol = '';
  double quantidade = 0;

  double get _valorMaximo => widget.quantidadeDisponivel * widget.moeda.valor;

  Future<void> _venderAgora() async {
    if (_form.currentState!.validate()) {
      final valorDigitado = Formatters.moedaToDouble(_currencyFormatter);
      try {
        await context.read<ContaRepository>().vendaCarrinho(
            [CartItem(moeda: widget.moeda, valorReais: valorDigitado)]);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venda realizada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  void _venderTudo() {
    _valor.value = _currencyFormatter.formatEditUpdate(
      _valor.value,
      TextEditingValue(
        text: _valorMaximo.toStringAsFixed(2).replaceAll('.', ','),
        selection: TextSelection.collapsed(
          offset: _valorMaximo.toStringAsFixed(2).length,
        ),
      ),
    );

    setState(() {
      quantidade = widget.quantidadeDisponivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final theme = Theme.of(context);
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
      appBar: AppBar(
        elevation: 0,
        title: const Text("VENDER"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.asset(widget.moeda.icone, width: 48, height: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.moeda.nome,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(widget.moeda.sigla,
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      Formatters.moeda(settings, widget.moeda.valor),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Disponível na carteira',
                          style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.quantidadeDisponivel.toStringAsFixed(6)} ${widget.moeda.sigla}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '≈ ${Formatters.moeda(settings, _valorMaximo)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _venderTudo,
                    child: const Text('VENDER TUDO'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: quantidade > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '≈ ${quantidade.toStringAsFixed(8)} ${widget.moeda.sigla}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _form,
              child: TextFormField(
                controller: _valor,
                decoration: InputDecoration(
                  labelText: 'Valor em $symbol',
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [_currencyFormatter],
                validator: (value) {
                  final valorDigitado =
                      Formatters.moedaToDouble(_currencyFormatter);

                  if (value == null || value.isEmpty || valorDigitado == 0) {
                    return 'Informe um valor!';
                  }

                  if (valorDigitado < 1) {
                    return 'Valor mínimo é ${settings.real.format(1)}';
                  }

                  if (valorDigitado > _valorMaximo + 0.000000001) {
                    return 'Valor máximo é ${Formatters.moeda(settings, _valorMaximo)}';
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
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: _venderAgora,
              icon: const Icon(Icons.trending_down),
              label: const Text('VENDER AGORA'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
