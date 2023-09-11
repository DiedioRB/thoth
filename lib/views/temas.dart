import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_tema.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';

class Temas extends StatefulWidget {
  const Temas({super.key});

  @override
  State<Temas> createState() => _TemasState();
}

class _TemasState extends State<Temas> {
  List<Tema> _temas = [];
  List<Topico> todosTopicos = [];
  List<Topico> topicos = [];

  Tema novoTema = Tema(descricao: "", topicosReferences: [], id: null);
  late FormBuilder formBuilder;
  StreamSubscription? watcher;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore db = FirebaseFirestore.instance;
    watcher = Tema.getCollection(db).snapshots().listen(listen);
  }

  void listen(value) {
    List<Tema> temas = [];
    if (value.docs.isNotEmpty) {
      for (var tema in value.docs) {
        temas.add(tema.data() as Tema);
      }
      _temas.clear();
      setState(() {
        _temas = temas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Temas"),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _temas.length,
              prototypeItem: ItemTema(
                tema: Tema(descricao: "", topicosReferences: []),
                modifiable: true,
              ),
              itemBuilder: (context, index) {
                return ItemTema(
                  tema: _temas[index],
                  modifiable: true,
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.cadastroTema);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    if (watcher != null) {
      watcher!.cancel();
      watcher = null;
    }
    super.dispose();
  }
}
