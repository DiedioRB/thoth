import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/lista_cards.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/routes.dart';

class Flashcards extends StatefulWidget {
  final Tema? tema;
  final Deck? deck;
  const Flashcards({super.key, this.tema, this.deck});

  @override
  State<Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  List<Pergunta> _perguntas = [];

  Tema? tema;
  Deck? deck;

  StreamSubscription? watcher;

  @override
  void initState() {
    super.initState();
    tema = widget.tema;
    deck = widget.deck;

    FirebaseFirestore db = FirebaseFirestore.instance;
    if (deck != null) {
      perguntasDoDeck();
    } else {
      if (tema == null) {
        watcher = Pergunta.getCollection(db).snapshots().listen(listen);
      } else {
        watcher = Pergunta.getCollection(db)
            .where("tema", isEqualTo: tema!.id)
            .snapshots()
            .listen(listen);
      }
    }
  }

  void listen(value) {
    List<Pergunta> perguntas = [];
    if (value.docs.isNotEmpty) {
      for (var pergunta in value.docs) {
        perguntas.add(pergunta.data() as Pergunta);
      }
      _perguntas.clear();
      setState(() {
        _perguntas = perguntas;
      });
    }
  }

  void perguntasDoDeck() async {
    _perguntas = await deck!.perguntas;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Flashcards"),
      ),
      body: Center(
        child: Column(
          children: [
            (_perguntas.isEmpty)
                ? const Text("Nenhum registro encontrado")
                : Expanded(child: ListaCards(perguntas: _perguntas)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.cadastroPerguntas);
        },
        tooltip: "Novo",
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
