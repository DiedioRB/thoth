import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_topico.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/ranking.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/routes.dart';

class Topicos extends StatefulWidget {
  final bool? isAdmin;
  final Tema? tema;

  const Topicos({super.key, this.tema, this.isAdmin = false});

  @override
  State<Topicos> createState() => _TopicosState();
}

class _TopicosState extends State<Topicos> {
  List<Topico> _topicos = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  Tema? tema;

  Topico novoTopico = Topico(descricao: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;
  StreamSubscription? watcher;

  @override
  void initState() {
    super.initState();
    tema = widget.tema;

    formBuilder = FormBuilder(Topico.getFields());

    FirebaseFirestore db = FirebaseFirestore.instance;
    if (tema == null) {
      watcher = Topico.getCollection(db).snapshots().listen(listen);
    } else {
      watcher = Topico.getCollection(db)
          .where(
            "tema",
          )
          .snapshots()
          .listen(listen);
      watcher = Tema.getCollection(db)
          .where(FieldPath.documentId, isEqualTo: tema!.id)
          .snapshots()
          .listen(listenFromTema);
    }
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

  void listenFromTema(value) async {
    List<Topico> topicos = [];
    if (value.docs.isNotEmpty) {
      topicos = await (value.docs.first.data() as Tema).topicos;
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.rankingTema, arguments: widget.tema);
            },
            icon: const Icon(Icons.format_list_numbered),
            tooltip: "Ranking",
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            itemCount: _topicos.length,
            itemBuilder: (context, index) {
              return ItemTopico(
                tema: widget.tema!,
                topico: _topicos[index],
                modifiable: widget.isAdmin ?? false,
              );
            }),
      ),
      floatingActionButton: (widget.isAdmin ?? false)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.cadastroTopico);
              },
              child: const Icon(Icons.add),
            )
          : null,
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
