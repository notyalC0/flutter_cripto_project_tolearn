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
  // Variável que controla qual página está sendo exibida
  // Começa em 0 pois arrays são indexados a partir do zero
  int pageIndex = 0;

  // Lista das páginas disponíveis na navegação
  // final = não será reatribuída, mas o conteúdo pode mudar
  // List<Widget> = lista que aceita qualquer Widget como item
  final List<Widget> _paginas = [
    const MoedasPage(), // index 0
    const FavoritasPage(),
    const CompradasPage(),
    const ConfiguracoesPage(),
    // index 1
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold é a estrutura base de uma tela no Flutter
    // Fornece AppBar, Body, BottomNavigationBar, Drawer, FAB, etc.
    return Scaffold(
      // body é o conteúdo principal da tela
      body: IndexedStack(
        // IndexedStack mantém TODOS os widgets filhos na memória
        // mas exibe apenas o do index atual
        // Vantagem: preserva o estado das páginas ao trocar de aba
        // Alternativa mais leve: trocar _paginas[pageIndex] direto no body,
        // porém perde o estado ao navegar (ex: scroll, formulários)
        index: pageIndex,
        children: _paginas,
      ),

      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        // Sincroniza o item destacado com a página atual
        currentIndex: pageIndex,
        backgroundColor: Colors.blueGrey,
        // onTap é chamado quando o usuário toca em um item
        // setState() avisa o Flutter que algo mudou e reconstrói o widget
        // sem setState() a tela não atualizaria visualmente
        onTap: (index) => setState(() => pageIndex = index),
        type: BottomNavigationBarType.fixed,
        // IMPORTANTE: com 3 ou mais itens, adicione esta linha:
        // type: BottomNavigationBarType.fixed,
        // Sem ela, os labels das abas não selecionadas ficam ocultos

        // const = os itens são criados uma vez e reutilizados (melhor performance)
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Moedas' // index 0 — deve corresponder a _paginas[0]
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favoritas' // index 1 — deve corresponder a _paginas[1]
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Carteira' // index 2 — deve corresponder a _paginas[2]
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Conta' // index 3 — deve corresponder a _paginas[3]
              ),
        ],
      ),
    );
  }
}
