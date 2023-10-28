import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/components/botao.dart';

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

  final FormBuilder form = FormBuilder(Usuario.getFieldsLogin());

  void _login(String? email, String? senha) async {
    Usuario? u;
    if (email != null && senha != null) {
      u = await Usuario.login(email, senha);
    }
    if (u == null) {
      _mostrarUsuarioIncorreto();
    }
  }

  void _mostrarUsuarioIncorreto() {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text("Usuário ou senha incorretos!")));
  }

  void esqueciMinhaSenha() {
    TextEditingController emailController =
        TextEditingController(text: form.values['email']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Esqueci minha senha"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: "Digite seu e-mail"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.value.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Uma mensagem foi enviada ao e-mail digitado")));
                },
                child: const Text("Enviar"))
          ],
        );
      },
    );
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
        child: Scaffold(
          backgroundColor: TemaApp.darkPrimary,
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                child:  Column(
                  children: [
                    Expanded(
                        flex: 1,
                        //APENAS REPRESENTATIVO
                        child: Container(
                          //child: const Icon(
                          //  Icons.add,
                          //  color: Colors.white,
                          //  size: 255,
                          //),
                        )
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration:BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)
                              ),
                              color: TemaApp.branco
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 30),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: TemaApp.darkSecondary,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 42, right: 42, bottom: 20),
                                child: form.build(),
                              ),

                              Container(
                                margin: const EdgeInsets.only(top: 25),
                                child:  Botao(
                                    texto: "Entrar",
                                    corFundo: TemaApp.darkPrimary,
                                    corTexto: TemaApp.branco,
                                    callback: () {
                                      _login(form.values['email'], form.values['senha']);
                                    }
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Não tem acesso? Cadastre-se ",
                                      style: TextStyle(
                                          fontSize: 18
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () =>
                                      {Navigator.of(context).pushNamed(Routes.cadastroUsuario)},
                                      child: const Text(
                                        "aqui",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                child: InkWell(
                                  onTap: () => {esqueciMinhaSenha()},
                                  child: const Text(
                                    "Esqueci minha senha",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            )

        )
    );
  }
}
