import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_topico.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/routes.dart';

class Topicos extends StatefulWidget {
  const Topicos({super.key});

  @override
  State<Topicos> createState() => _TopicosState();
}

class _TopicosState extends State<Topicos> {
  List<Topico> _topicos = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  Topico novoTopico = Topico(descricao: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;
  StreamSubscription? watcher;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Topico.getFields());

    FirebaseFirestore db = FirebaseFirestore.instance;
    watcher = Topico.getCollection(db).snapshots().listen(listen);
  }

  void listen(value) {
    List<Topico> topicos = [];
    if (value.docs.isNotEmpty) {
      for (var topico in value.docs) {
        topicos.add(topico.data() as Topico);
      }
      _topicos.clear();
      setState(() {
        _topicos = topicos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Tópicos"),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _topicos.length,
              prototypeItem: ItemTopico(
                topico: Topico(descricao: "", perguntasReferences: []),
                modifiable: true,
              ),
              itemBuilder: (context, index) {
                return ItemTopico(topico: _topicos[index]);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.cadastroTopico);
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
