import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../config/app.settings.dart';
import '../repositories/conta_repository.dart';
import 'package:flutter_app/helpers/formatters.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final conta = context.watch<ContaRepository>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CONFIGURAÇÕES'),
        centerTitle: true,
      ),
      body: ListView(
        // Alterado para ListView para garantir que role em telas pequenas
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- SEÇÃO: APARÊNCIA ---
          _buildSectionHeader(theme, 'Aparência'),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: SwitchListTile(
              title: const Text('Modo Escuro'),
              secondary: const Icon(Icons.brightness_6),
              value: settings.isDark,
              onChanged: (value) => settings.setTheme(value),
            ),
          ),
          const SizedBox(height: 20),

          // --- SEÇÃO: LOCALIZAÇÃO ---
          _buildSectionHeader(theme, 'Preferências'),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Moeda de Exibição'),
            subtitle: Text(
                settings.localeCode == 'pt-BR' ? 'Real (R\$)' : 'Dólar (US\$)'),
            trailing: const Icon(Icons.swap_horiz),
            onTap: () {
              if (settings.localeCode == 'pt-BR') {
                settings.setLocale('en-US', '\$');
              } else {
                settings.setLocale('pt-BR', 'R\$');
              }
            },
          ),
          const Divider(),

          // --- SEÇÃO: CONTA ---
          _buildSectionHeader(theme, 'Minha Conta'),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Saldo em Conta'),
            subtitle: Text(Formatters.formatCurrency(settings, conta.saldo)),
            trailing: IconButton(
              onPressed: updateSaldo,
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

// Helper para criar títulos de seção elegantes
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = context.read<ContaRepository>();

    valor.text = conta.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: const Text('Atualizar Saldo'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: valor,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um valor';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                conta.setSaldo(double.parse(valor.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Atualizar'))
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }
}
