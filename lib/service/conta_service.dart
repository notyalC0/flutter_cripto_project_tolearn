import 'dart:convert';
import 'package:flutter_app/models/favoritas.dart';
import 'package:http/http.dart' as http;
import '../models/conta.dart';
import '../models/carteira.dart';
import '../models/historico.dart';

class ContaService {
  final String urlbase = 'http://localhost:8080/api';

/*
Respostas Informativas (100 – 199)
Respostas bem-sucedidas (200 – 299)
Mensagens de redirecionamento (300 – 399)
Respostas de erro do cliente (400 – 499)
Respostas de erro do servidor (500 – 599)
*/

// Receber dados da Api

  Future<List<Conta>> fetchContas() async {
    final response = await http.get(Uri.parse('$urlbase/conta'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Conta.fromJson(i)).toList();
    } else {
      throw Exception('Não foi possivel obter os dados para contas!');
    }
  }

  Future<List<Historico>> fetchHistorico() async {
    final response = await http.get(Uri.parse('$urlbase/historico'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Historico.fromJson(i)).toList();
    } else {
      throw Exception('Não foi possivel obter os dados para historico!');
    }
  }

  Future<List<Carteira>> fetchCarteira() async {
    final response = await http.get(Uri.parse('$urlbase/carteira'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Carteira.fromJson(i)).toList();
    } else {
      throw Exception('Não foi possivel obter os dados para carteira!');
    }
  }

  Future<List<Favoritas>> fetchFavoritas() async {
    final response = await http.get(Uri.parse('$urlbase/favoritas'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Favoritas.fromJson(i)).toList();
    } else {
      throw Exception('Não foi possivel obter os dados para favoritas!');
    }
  }

  // Mandar dados para a api

  Future<void> addConta(Conta conta) async {
    final response = await http.post(Uri.parse('$urlbase/conta'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(conta.toJson()));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel enviar os dados para a conta!');
    }
  }

  Future<void> addHistorico(Historico historico) async {
    final response = await http.post(Uri.parse('$urlbase/historico'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(historico.toJson()));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel enviar os dados para o historico!');
    }
  }

  Future<void> addCarteira(Carteira carteira) async {
    final response = await http.post(Uri.parse('$urlbase/carteira'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(carteira.toJson()));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel enviar os dados para a carteira!');
    }
  }

  Future<void> addFavoritas(Favoritas favoritas) async {
    final response = await http.post(Uri.parse('$urlbase/favoritas'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(favoritas.toJson()));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel enviar os dados para as favoritas!');
    }
  }

  // Atualizar dados da api

  Future<void> updateConta(Conta conta) async {
    final response = await http.put(Uri.parse('$urlbase/conta/${conta.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(conta.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Não foi possivel atualizar os dados para a conta!');
    }
  }

  Future<void> updateHistorico(Historico historico) async {
    final response = await http.put(
        Uri.parse('$urlbase/historico/${historico.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(historico.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Não foi possivel atualizar os dados para o historico!');
    }
  }

  Future<void> updateCarteira(Carteira carteira) async {
    final response = await http.put(
        Uri.parse('$urlbase/carteira/${carteira.sigla}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(carteira.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Não foi possivel atualizar os dados para a carteira!');
    }
  }

  Future<void> updateFavoritas(Favoritas favoritas) async {
    final response = await http.put(
        Uri.parse('$urlbase/favoritas/${favoritas.sigla}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(favoritas.toJson()));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel enviar os dados para as favoritas!');
    }
  }

  // Deletar dados da api

  Future<void> deletarConta(int id) async {
    final response = await http.delete(Uri.parse("$urlbase/conta/$id"));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel deletar os dados para a conta!');
    }
  }

  Future<void> deletarHistorico(int id) async {
    final response = await http.delete(Uri.parse("$urlbase/historico/$id"));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel deletar os dados para o historico!');
    }
  }

  Future<void> deletarCarteira(String sigla) async {
    final response = await http.delete(Uri.parse("$urlbase/carteira/$sigla"));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel deletar os dados para a carteira!');
    }
  }

  Future<void> deletarFavoritas(String sigla) async {
    final response = await http.delete(Uri.parse('$urlbase/favoritas/$sigla'));
    if (response.statusCode != 200) {
      throw Exception('Não foi possivel deletar os dados para as favoritas!');
    }
  }
}
