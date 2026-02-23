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
    // Scaffold é a estrutura base da tela

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritas'),
      ),
      body: Container(
          color: Colors.blueGrey.withOpacity(0.05),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: Consumer<FavoritasRepository>(
              builder: (context, favoritas, child) {
            return favoritas.lista.isEmpty
                ? const ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Ainda não há moedas favoritas'),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.90,
                    ),
                    itemCount: favoritas.lista.length,
                    itemBuilder: (context, index) {
                      return MoedasCard(
                        moeda: favoritas.lista[index],
                        showRemove: true,
                      );
                    },
                  );
          })),
      //body é o corpo da tela
    );
  }
}
