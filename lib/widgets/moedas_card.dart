import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/formatters.dart';
import 'package:flutter_app/models/moeda.dart';
import 'package:flutter_app/pages/moedas_detalhes_page.dart';
import 'package:flutter_app/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';

import '../config/app.settings.dart';

class MoedasCard extends StatelessWidget {
  final Moeda moeda;
  final bool showRemove;
  final bool selecionada;
  final VoidCallback? onLongPress;
  final String? tagPrefix;

  // StatelessWidget pois o card só exibe dados, não tem estado próprio
  const MoedasCard(
      {Key? key,
      required this.moeda,
      this.showRemove = false,
      this.selecionada = false,
      this.onLongPress,
      this.tagPrefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(6),
      // Cor muda quando selecionado
      color: selecionada
          ? theme.colorScheme.primary.withOpacity(0.1)
          : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Borda azul quando selecionado
        side: BorderSide(
          color: selecionada
              ? theme.colorScheme.primary
              : theme.dividerColor.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MoedasDetalhesPage(
                    moeda: moeda,
                    tagPrefix: tagPrefix ?? '',
                  )),
        ),
        onLongPress: onLongPress, // null = sem ação, definido pela página pai
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showRemove)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<FavoritasRepository>(
                        context,
                        listen: false,
                      ).remove(moeda);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                  ),
                ),

              // Ícone de check quando selecionado, imagem quando não
              selecionada
                  ? CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.check, color: Colors.white),
                    )
                  : Hero(
                      tag: '${tagPrefix ?? ''}${moeda.sigla}',
                      child: Image.asset(moeda.icone, width: 48, height: 48),
                    ),

              const SizedBox(height: 12),
              Text(
                moeda.nome,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                moeda.sigla,
                style:
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 8),
              Text(
                Formatters.moeda(settings, moeda.valor),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
