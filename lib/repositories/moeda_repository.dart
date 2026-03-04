import 'package:flutter_app/models/moeda.dart';

import '../service/conta_service.dart';

class MoedaRepository {
  final _service = ContaService();
  static List<Moeda> tabela = [];

  Future<void> carregarMoedas() async {
    final moedas = await _service.fetchMoedas();
    tabela = moedas;
  }
}
