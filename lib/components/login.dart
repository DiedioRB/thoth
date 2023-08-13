import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/usuario.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _login(String email, String senha) async {
    Usuario? usuario = await Usuario.login(email, senha);
    if (usuario != null) {
      print(usuario);
    } else {
      print("Usuário não encontrado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => _login("andreribas0511@gmail.com", "yosenha123"),
        child: const Text("Login"));
  }
}
