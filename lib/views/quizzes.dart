import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_quiz.dart';
import 'package:thoth/components/pesquisa.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';

class Quizzes extends StatefulWidget {
  final Tema? tema;
  final Topico? topico;
  final bool modifiable;

  const Quizzes({super.key, this.tema, this.topico, this.modifiable = false});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> with Pesquisa<Quiz> {
  List<Quiz> _quizzes = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  Topico? topico;

  Quiz novoQuiz = Quiz(nome: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;
  StreamSubscription? watcher;

  @override
  void initState() {
    super.initState();

    topico = widget.topico;

    formBuilder = FormBuilder(Quiz.getFields());

    FirebaseFirestore db = FirebaseFirestore.instance;
    if (topico == null) {
      watcher = Quiz.getCollection(db).snapshots().listen(listen);
    } else {
      watcher = Quiz.getCollection(db)
          .where("topico", isEqualTo: topico!.id)
          .snapshots()
          .listen(listen);
    }

    searchController.addListener(() {
      setState(() {
        search(_quizzes);
      });
    });
  }

  void listen(value) {
    List<Quiz> quizzes = [];
    if (value.docs.isNotEmpty) {
      for (var quiz in value.docs) {
        quizzes.add(quiz.data() as Quiz);
      }
      _quizzes.clear();
      setState(() {
        _quizzes = quizzes;
        search(_quizzes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TemaApp.quizPrimary,
        title: const Text("Quizzes"),
      ),
      body: Center(
          child: Column(
        children: [
          barraPesquisa(),
          (itensPesquisa.isEmpty)
              ? const Text("Nenhum registro encontrado")
              : Expanded(
                  child: ListView.builder(
                      itemCount: itensPesquisa.length,
                      prototypeItem: ItemQuiz(
                        tema: widget.tema,
                        topico: topico,
                        quiz: Quiz(nome: "", perguntasReferences: []),
                        modifiable: widget.modifiable,
                      ),
                      itemBuilder: (context, index) {
                        return ItemQuiz(
                          tema: widget.tema,
                          topico: topico,
                          quiz: itensPesquisa[index],
                          modifiable: widget.modifiable,
                        );
                      }),
                ),
        ],
      )),
      floatingActionButton: widget.modifiable
          ? FloatingActionButton(
              backgroundColor: TemaApp.quizPrimary,
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.cadastroQuiz);
              },
              tooltip: "Novo quiz",
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
