import 'package:flutter/material.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/components/botao.dart';


class CadastroUsuario extends StatelessWidget {
  CadastroUsuario({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();

  void _cadastrar(String nome, String email, String senha, String senhaRepetida) async {

    //adicionar validador de campos em branco
    //adicionar validador de campo de email
    // adicionar limite mínimo de caracteres pra senha
    //adicionar erros vindos em snackbar. Para isso, transformar Material em Scaffold
    if (senha == senhaRepetida) {
      try {
        AuthHelper.registerUsingEmailAndPassword(
            nome: nome, email: email, senha: senha
        );
      } catch (e){
        print("Erro no try: $e");
      }

    } else {
      print("Não Okay.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          backgroundColor: TemaApp.darkPrimary,
          body: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container()
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
                            margin: const EdgeInsets.only(top: 30),
                            child: Text(
                              "BEM VINDO!",
                              style: TextStyle(
                                  color: TemaApp.darkSecondary,
                                  fontSize: 35,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 42, right: 42, top: 35, bottom: 20),
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(labelText: "Nome"),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(labelText: "Email"),
                                ),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: "Senha"),
                                ),
                                TextField(
                                    controller: passwordRepeatController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        labelText: "Repita a senha"))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Botao(
                                texto: "Cadastrar-se",
                                corFundo: TemaApp.darkPrimary,
                                corTexto: TemaApp.branco,
                                callback: () => _cadastrar(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    passwordRepeatController.text
                                )
                            )
                          ),

                        ],
                      ))
              )
            ],
          ),
        )

    );
  }
}
