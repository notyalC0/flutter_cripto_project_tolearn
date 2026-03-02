import 'package:flutter/material.dart';
import 'package:flutter_app/pages/compradas_page.dart';
import 'configuracoes_page.dart';
import 'favoritas_page.dart';
import 'moedas_page.dart';

// StatefulWidget é usado quando a tela precisa de estado mutável (variáveis que mudam)
// Use StatelessWidget quando a tela não muda após ser construída
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // createState() conecta o widget ao seu estado (_HomePageState)
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final List<Widget> _paginas = [
    const MoedasPage(),
    const FavoritasPage(),
    const CompradasPage(),
    const ConfiguracoesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: _paginas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) => setState(() => pageIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.hintColor.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Moedas',
            activeIcon: Icon(Icons.monetization_on),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: 'Favoritas',
            activeIcon: Icon(Icons.star),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined),
            label: 'Carteira',
            activeIcon: Icon(Icons.wallet),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Conta',
            activeIcon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}
