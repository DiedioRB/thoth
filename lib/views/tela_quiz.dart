import 'package:flutter/material.dart';
import 'package:thoth/components/menu_lateral.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/models/pergunta.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  void _logout(BuildContext context) {
    AuthHelper.logout();
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  void _teste() {
    print('IRRÃ');
    Pergunta.getCollection(db).where(field);
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
                      margin: const EdgeInsets.only(top: 250.0),
                      height: 60,
                      width: 250,
                      decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.tealAccent),
                      child: TextButton(
                          onPressed: () => _teste(),
                          child: const Text("Temas",
                              style:
                              TextStyle(color: Colors.black, fontSize: 20.0))),
                    )
                  ],
                )
            )
        )
    );
  }
}
