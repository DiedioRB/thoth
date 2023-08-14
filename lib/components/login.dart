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
    return Material(
      child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100.0),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 35.0
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 42.0,
                  right: 42.0,
                  top: 100.0,
                  bottom: 35.0
                ),
                child: const Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email"
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password"
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 100.0),
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue[50]
                ),
                child: TextButton(
                    onPressed: () => _login("andreribas0511@gmail.com", "yosenha123"),
                    child: const Text(
                        "Entrar",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20.0
                        )
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:25.0),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                          "Não tem acesso? Cadastre-se "
                      ),
                      TextButton(
                          onPressed: () => {print("Cadastrado!")},
                          child: Text(
                            "Aqui",
                            style: TextStyle(
                                color: Colors.blueAccent
                            ),
                          )
                      )
                    ],
                  ) ,
                )
              )
            ],
          )
      )
    );
  }
}
