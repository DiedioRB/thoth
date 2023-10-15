import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late StreamSubscription userListener;
  bool isObscureText = true;

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
    return Scaffold(
       backgroundColor: TemaApp.purple,
        body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height
                ),
              child: SizedBox(
                width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: Container()),
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)
                            )
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: TemaApp.purple,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 42.0, right: 42.0, top: 100.0, bottom: 35.0),
                                  child: form.build(),
                                ),
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 30),
                                alignment: Alignment.center,
                              )
                            ],
                          ),
                        ),
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
                        margin: const EdgeInsets.only(top: 25, left: 100),
                        child: Row(
                          children: [
                            const Center(
                                child: Text("Não tem acesso? Cadastre-se ")
                            ),
                            Center(
                              child: InkWell(
                                onTap: () => {
                                  Navigator.of(context).pushNamed( Routes.cadastroUsuario)
                                },
                                child: const Text(
                                  "Aqui",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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
                  )
              ),
            ),
        )
    );
  }
}
