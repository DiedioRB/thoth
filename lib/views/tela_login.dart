import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/routes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late StreamSubscription userListener;

  void _setUpFirebaseAuth() {
    userListener = FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        //Caso encontre o login, redireciona para o menu
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed(Routes.menu);
      }
    });
  }

  final FormBuilder form = FormBuilder(Usuario.getFields(
      usuario:
          Usuario(nome: "", email: "andreribas0511@gmail.com", salas: [])));

  void _login(String? email, String? senha) async {
    if (email != null && senha != null) {
      await Usuario.login(email, senha);
    }
  }

  @override
  void initState() {
    //Adiciona um observer para verificar se o login funcionou
    _setUpFirebaseAuth();
    super.initState();
  }

  @override
  void dispose() {
    userListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 35.0),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 42.0, right: 42.0, top: 100.0, bottom: 35.0),
                  child: form.build(),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[50]),
                  child: TextButton(
                      //onPressed: () => _login("andreribas0511@gmail.com", "yosenha123"),
                      // onPressed: () =>
                      //     _login(emailController.text, passwordController.text),
                      onPressed: () {
                        _login(form.values['email'], form.values['senha']);
                      },
                      child: const Text("Entrar",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0))),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Row(
                        children: [
                          const Text("Não tem acesso? Cadastre-se "),
                          TextButton(
                              onPressed: () => {
                                    Navigator.pushNamed(
                                        context, Routes.cadastro)
                                  },
                              child: const Text(
                                "Aqui",
                                style: TextStyle(color: Colors.blueAccent),
                              ))
                        ],
                      ),
                    )),
                InkWell(
                  onTap: () => {
                    FirebaseAuth.instance.sendPasswordResetEmail(
                        email: "andreribas0511@gmail.com")
                  },
                  child: const Text(
                    "Esqueci minha senha",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                )
              ],
            )));
  }
}
