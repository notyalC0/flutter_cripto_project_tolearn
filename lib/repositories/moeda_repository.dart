import 'package:flutter_app/models/moeda.dart';

import '../service/api_service.dart';

class MoedaRepository {
  final _service = ApiService();
  static List<Moeda> tabela = [];

  Future<void> carregarMoedas() async {
    final moedas = await _service.fetchMoedas();
    tabela = moedas;
  }
}
