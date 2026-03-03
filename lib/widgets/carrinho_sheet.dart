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
    final theme = Theme.of(context);

    if (cart.items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Meu Carrinho',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded)),
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: cart.items.isEmpty
                  ? _buildEmptyState(theme)
                  : _buildCartList(cart, settings, theme, context),
            ),
          ),
          const Divider(),
          const SizedBox(height: 12),
          _buildFinancialRow('Saldo em conta:',
              Formatters.formatCurrency(settings, conta.saldo), theme),
          const SizedBox(height: 8),
          _buildFinancialRow('Total a pagar:',
              Formatters.formatCurrency(settings, cart.totalReais), theme,
              isTotal: true),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: cart.items.isEmpty
                  ? null
                  : () => _finishPurchase(context, cart),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('FINALIZAR COMPRA',
                  style: TextStyle(
                      letterSpacing: 1.1, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 60, color: theme.hintColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('Seu carrinho está vazio',
              style: TextStyle(color: theme.hintColor)),
        ],
      ),
    );
  }

  Widget _buildCartList(CartRepository cart, AppSettings settings,
      ThemeData theme, BuildContext context) {
    return ListView.separated(
      key: const ValueKey('list'),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final item = cart.items[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(item.moeda.icone, width: 32),
          title: Text(item.moeda.nome,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
              '${item.quantidadeMoeda.toStringAsFixed(6)} ${item.moeda.sigla}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Formatters.formatCurrency(settings, item.valorReais),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline,
                    color: Colors.redAccent, size: 22),
                onPressed: () =>
                    context.read<CartRepository>().remove(item.moeda),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinancialRow(String label, String value, ThemeData theme,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? null : theme.hintColor)),
        Text(value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? theme.colorScheme.primary : null,
            )),
      ],
    );
  }

  Future<void> _finishPurchase(
      BuildContext context, CartRepository cart) async {
    try {
      await context.read<ContaRepository>().checkoutCarrinho(cart.items);
      cart.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Compra realizada com sucesso!'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}
