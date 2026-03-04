import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../models/login.dart';
import '../repositories/cart_repository.dart';
import '../repositories/conta_repository.dart';
import '../service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _mostrarSenha = false;
  bool _isLoading = false;
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _efetuarLogin() async {
    String senha = _senhaController.text;
    String email = _emailController.text;
    setState(() => _isLoading = true);

    try {
      await authService.login(Login(
        email: email,
        senha: senha,
      ));

      if (mounted) {
        context.read<CartRepository>().clear();
        context.read<ContaRepository>().reset();
        context.read<ContaRepository>().refreshAll();
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      if (mounted) _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                          icon: Icon(_mostrarSenha
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      labelText: "Senha",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _efetuarLogin();
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ))
                ]),
          ),
        ),
      ),
    );
  }
}
