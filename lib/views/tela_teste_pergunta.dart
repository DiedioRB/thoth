import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/menu_lateral.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/models/pergunta.dart';

class PerguntaTeste extends StatelessWidget {
  const PerguntaTeste({super.key});

  void _logout(BuildContext context) {
    AuthHelper.logout();
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  void _teste() async {
    //final FirebaseApp app = Firebase.app();
    //final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
    List<String> teste = ["um", "dois", "três"];
    await Pergunta.create("teste", teste, 8);
    //var perg;
    //Pergunta.getCollection(db)
    //    .get()
    //    .then((value) {
    //      perg = value.docs.first.data();
    //      print("\n\n t== ${perg}");
   //});

    //print("\n\n TESTE: ${perg}");

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
                          onPressed: () => {
                              _teste(),
                          },
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
