import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/favoritas_repository.dart';
import '../widgets/moedas_card.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({Key? key}) : super(key: key);

  @override
  _FavoritasPageState createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Scaffold é a estrutura base da tela

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORITAS'),
        centerTitle: true,
      ),
      body: Consumer<FavoritasRepository>(
        builder: (context, favoritas, child) {
          if (favoritas.lista.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_outline,
                    size: 64,
                    color: theme.hintColor.withOpacity(0.3),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Ainda não há favoritas adicionadas!",
                    style: TextStyle(color: theme.hintColor),
                  )
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.90,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: favoritas.lista.length,
            itemBuilder: (context, index) {
              return MoedasCard(
                moeda: favoritas.lista[index],
                tagPrefix: 'fav_',
                showRemove: true,
              );
            },
          );
        },
      ),
    );
  }
}
