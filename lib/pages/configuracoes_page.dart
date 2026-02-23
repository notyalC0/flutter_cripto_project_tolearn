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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tema', style: Theme.of(context).textTheme.titleLarge),
            SwitchListTile(
              title: const Text('Modo Escuro'),
              value: settings.isDark,
              onChanged: (value) {
                settings.setTheme(value);
              },
            ),
            const SizedBox(height: 20),
            Text('Moeda',
                style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: const Text('Moeda'),
              subtitle:
                  Text(settings.localeCode == 'pt-BR' ? 'R\$' : 'US\$'),
              trailing: IconButton(
                onPressed: () {
                  if (settings.localeCode == 'pt-BR') {
                    context.read<AppSettings>().setLocale('en-US', '\$');
                  } else {
                    context.read<AppSettings>().setLocale('pt-BR', 'R\$');
                  }
                },
                icon: const Icon(Icons.language),
              ),
            ),
            const Divider(),
            Text('Configurações de Conta',
                style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: const Text('Saldo Atual'),
              subtitle:
                  Text(' ${Formatters.formatCurrency(settings, conta.saldo)}'),
              trailing: IconButton(
                onPressed: updateSaldo,
                icon: const Icon(Icons.edit),
              ),
            ),
            const Divider(),
          ],
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
