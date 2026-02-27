import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login.dart';

class AuthService {
  final String urlbase = "http://localhost:8080";
  static const String _tokenKey = "jwt_token";

  Future<void> login(Login login) async {
    final response = await http.post(Uri.parse('$urlbase/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(login.toJson()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_tokenKey, token);
      return;
    }

    if (response.statusCode == 403) {
      throw Exception('Email ou senha esta incorreto');
    }

    throw Exception('Erro ao fazer login: ${response.statusCode}');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<bool> estaLogado() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logOut() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_tokenKey);
  }
}
