import 'package:flutter/material.dart';
import 'package:thoth/helpers/auth_helper.dart';


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
      print("Okay");
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
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  child: const Text(
                    "CADASTRO",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 35.0),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 42.0, right: 42.0, top: 85.0, bottom: 35.0),
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
                  margin: const EdgeInsets.only(top: 100.0),
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue[50]),
                  child: TextButton(
                      //onPressed: () => _login("andreribas0511@gmail.com", "yosenha123"),
                      onPressed: () => _cadastrar(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          passwordRepeatController.text),
                      child: const Text("Cadastrar",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0))),
                ),
              ],
            )));
  }
}
