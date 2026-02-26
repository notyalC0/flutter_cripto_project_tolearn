import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app.settings.dart';
import '../helpers/formatters.dart';
import '../repositories/cart_repository.dart';
import '../repositories/conta_repository.dart';

class CarrinhoSheet extends StatelessWidget {
  const CarrinhoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartRepository>();
    final conta = context.watch<ContaRepository>();
    final settings = context.watch<AppSettings>();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Carrinho',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          if (cart.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Carrinho vazio'),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final item = cart.items[i];
                  return ListTile(
                    leading:
                        Image.asset(item.moeda.icone, width: 28, height: 28),
                    title: Text('${item.moeda.nome} (${item.moeda.sigla})'),
                    subtitle:
                        Text('Qtd: ${item.quantidadeMoeda.toStringAsFixed(6)}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(Formatters.formatCurrency(
                            settings, item.valorReais)),
                        TextButton(
                          onPressed: () =>
                              context.read<CartRepository>().remove(item.moeda),
                          child: const Text('Remover'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                  'Saldo: ${Formatters.formatCurrency(settings, conta.saldo)}'),
              const Spacer(),
              Text(
                'Total: ${Formatters.formatCurrency(settings, cart.totalReais)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: cart.items.isEmpty
                  ? null
                  : () async {
                      try {
                        await context
                            .read<ContaRepository>()
                            .checkoutCarrinho(cart.items);
                        context.read<CartRepository>().clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Compra finalizada!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(e
                                  .toString()
                                  .replaceFirst('Exception: ', ''))),
                        );
                      }
                    },
              icon: const Icon(Icons.check),
              label: const Text('Finalizar compra'),
            ),
          ),
        ],
      ),
    );
  }
}
