import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
//import 'package:thoth/components/item_quiz.dart'; - Comentado para verificar a necessidade

// Necessário avaliar se é preciso, e como iria funcionar esta tela de edição.

class EditarQuiz extends StatefulWidget {
  const EditarQuiz ({super.key});

  @override
  State<EditarQuiz> createState() => EQuizzesState();
}

class EQuizzesState extends State<EditarQuiz> {
  List<Quiz> eQuizzes = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  @override
  void initState() {
    super.initState();

    List<Quiz> quizzes = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Quiz.getCollection(db).get().then((value) => {
      if (value.docs.isNotEmpty)
        {
          for (var quiz in value.docs) {quizzes.add(quiz.data() as Quiz)},
          setState(() {
            eQuizzes = quizzes;
          })
        }
    });
  }

  void eQuiz(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
      for (var pergunta in value.docs)
        {todasPerguntas.add(pergunta.data() as Pergunta)}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text ("Editar Quiz"),
      ),
    );
  }
}