import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/favoritas.dart';
import 'package:flutter_app/service/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/conta.dart';
import '../models/carteira.dart';
import '../models/historico.dart';
import '../models/moeda.dart';

/*
Respostas Informativas (100 – 199)
Respostas bem-sucedidas (200 – 299)
Mensagens de redirecionamento (300 – 399)
Respostas de erro do cliente (400 – 499)
Respostas de erro do servidor (500 – 599)
*/

class ContaService {
  final String urlbase = 'http://localhost:8080/api';
  final AuthService _authService = AuthService();

// _headers

  Future<Map<String, String>> _headers() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

// Receber dados da Api

  Future<List<Moeda>> fetchMoedas() async {
    final response = await http.get(
      Uri.parse('$urlbase/moeda'),
      headers: await _headers(),
    );
    debugPrint("${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Moeda.fromJson(i)).toList();
    } else {
      throw Exception(
          'Não foi possivel obter os dados para as Moedas! | erro: ${response.statusCode}');
    }
  }

  Future<List<Conta>> fetchContas() async {
    final response = await http.get(
      Uri.parse('$urlbase/conta'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Conta.fromJson(i)).toList();
    } else {
      throw Exception(
          'Não foi possivel obter os dados para contas! | erro: ${response.statusCode}');
    }
  }

  Future<List<Historico>> fetchHistorico() async {
    final response = await http.get(
      Uri.parse('$urlbase/historico'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Historico.fromJson(i)).toList();
    } else {
      throw Exception(
          'Não foi possivel obter os dados para historico! | erro: ${response.statusCode}');
    }
  }

  Future<List<Carteira>> fetchCarteira() async {
    final response = await http.get(
      Uri.parse('$urlbase/carteira'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Carteira.fromJson(i)).toList();
    } else {
      throw Exception(
          'Não foi possivel obter os dados para carteira! | erro: ${response.statusCode}');
    }
  }

  Future<List<Favoritas>> fetchFavoritas() async {
    final response = await http.get(
      Uri.parse('$urlbase/favoritas'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((i) => Favoritas.fromJson(i)).toList();
    } else {
      throw Exception(
          'Não foi possivel obter os dados para favoritas! | erro: ${response.statusCode}');
    }
  }

  // Mandar dados para a api

  Future<Conta> addConta(Conta conta) async {
    final response = await http.post(Uri.parse('$urlbase/conta'),
        headers: await _headers(), body: jsonEncode(conta.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Conta.fromJson(
          jsonDecode(response.body)); // retorna a conta com id
    }
    throw Exception(
        'Nao foi possivel criar a conta! | erro: ${response.statusCode}');
  }

  Future<void> addHistorico(Historico historico) async {
    final response = await http.post(Uri.parse('$urlbase/historico'),
        headers: await _headers(), body: jsonEncode(historico.toJson()));
    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel enviar os dados para o historico! | erro: ${response.statusCode}');
    }
  }

  Future<void> addCarteira(Carteira carteira) async {
    final response = await http.post(Uri.parse('$urlbase/carteira'),
        headers: await _headers(), body: jsonEncode(carteira.toJson()));
    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel enviar os dados para a carteira! | erro: ${response.statusCode}');
    }
  }

  Future<void> addFavoritas(Favoritas favoritas) async {
    final response = await http.post(Uri.parse('$urlbase/favoritas'),
        headers: await _headers(), body: jsonEncode(favoritas.toJson()));
    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel enviar os dados para as favoritas! | erro: ${response.statusCode}');
    }
  }

  // Atualizar dados da api

  Future<void> updateConta(Conta conta) async {
    final response = await http.put(Uri.parse('$urlbase/conta/${conta.id}'),
        headers: await _headers(), body: jsonEncode(conta.toJson()));

    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel atualizar os dados para a conta! | erro: ${response.statusCode}');
    }
  }

  Future<void> updateHistorico(Historico historico) async {
    final response = await http.put(
        Uri.parse('$urlbase/historico/${historico.id}'),
        headers: await _headers(),
        body: jsonEncode(historico.toJson()));

    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel atualizar os dados para o historico! | erro: ${response.statusCode}');
    }
  }

  Future<void> updateCarteira(Carteira carteira) async {
    final response = await http.put(
        Uri.parse('$urlbase/carteira/${carteira.sigla}'),
        headers: await _headers(),
        body: jsonEncode(carteira.toJson()));

    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel atualizar os dados para a carteira! | erro: ${response.statusCode}');
    }
  }

  Future<void> updateFavoritas(Favoritas favoritas) async {
    final response = await http.put(
        Uri.parse('$urlbase/favoritas/${favoritas.sigla}'),
        headers: await _headers(),
        body: jsonEncode(favoritas.toJson()));
    if (response.statusCode != 200) {
      throw Exception(
          'Não foi possivel enviar os dados para as favoritas! | erro: ${response.statusCode}');
    }
  }

  // Deletar dados da api

  Future<void> deletarConta(int id) async {
    final response = await http.delete(
      Uri.parse("$urlbase/conta/$id"),
      headers: await _headers(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Não foi possivel deletar os dados para a conta! | erro: ${response.statusCode}');
    }
  }

  Future<void> deletarHistorico(int id) async {
    final response = await http.delete(
      Uri.parse("$urlbase/historico/$id"),
      headers: await _headers(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Não foi possivel deletar os dados para o historico! | erro: ${response.statusCode}');
    }
  }

  Future<void> deletarCarteira(String sigla) async {
    final response = await http.delete(
      Uri.parse("$urlbase/carteira/$sigla"),
      headers: await _headers(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Não foi possivel deletar os dados para a carteira! | erro: ${response.statusCode}');
    }
  }

  Future<void> deletarFavoritas(String sigla) async {
    final response = await http.delete(
      Uri.parse('$urlbase/favoritas/$sigla'),
      headers: await _headers(),
    );
    debugPrint("${response.statusCode}");
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Não foi possivel deletar os dados para as favoritas! | erro: ${response.statusCode}');
    }
  }
}
