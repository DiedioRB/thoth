import 'package:flutter/material.dart';
import 'package:thoth/components/menu_lateral.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/routes.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  void _logout(BuildContext context) {
    AuthHelper.logout();
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            drawer: const Drawer(
              child: MenuLateral(),
            ),
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                actions: [
                  IconButton(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    tooltip: "Desconectar",
                  )
                ]),
            body: Center(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber[50]),
                  child: TextButton(
                      onPressed: () {},
                      child: const Text("Temas",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber[50]),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.quizzes);
                      },
                      child: const Text("Quizzes",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurpleAccent[100]),
                  child: TextButton(
                      onPressed: () {},
                      child: const Text("Rankings",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen[100]),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.cadastroPerguntas);
                      },
                      child: const Text("Cadastrar Perguntas",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0))),
                ),
                TextButton(
                    onPressed: () => _logout(context),
                    child: const Text("logout")),
              ],
            ))));
  }
}
