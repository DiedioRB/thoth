import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_quiz.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/routes.dart';

class Quizzes extends StatefulWidget {
  const Quizzes({super.key});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  List<Quiz> _quizzes = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  Quiz novoQuiz = Quiz(nome: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Quiz.getFields(quiz: novoQuiz));

    List<Quiz> quizzes = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Quiz.getCollection(db).get().then((value) => {
          if (value.docs.isNotEmpty)
            {
              for (var quiz in value.docs) {quizzes.add(quiz.data() as Quiz)},
              setState(() {
                _quizzes = quizzes;
              })
            }
        });
  }

  void _novoModal(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
          for (var pergunta in value.docs)
            {todasPerguntas.add(pergunta.data() as Pergunta)}
        });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      formBuilder.build(),
                      Expanded(
                        child: ListView.builder(
                            itemCount: todasPerguntas.length,
                            itemBuilder: (context, index) {
                              Pergunta p = todasPerguntas[index];
                              return CheckboxListTile(
                                title: Text(p.pergunta),
                                value: perguntas.any(
                                  (element) => element.pergunta == p.pergunta,
                                ),
                                onChanged: (value) => {
                                  setState(() {
                                    if (value == false) {
                                      perguntas.removeWhere((element) {
                                        return element.pergunta == p.pergunta;
                                      });
                                    } else {
                                      perguntas.add(p);
                                    }
                                  })
                                },
                              );
                            }),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                List<DocumentReference> refs = [];
                                for (var pergunta in perguntas) {
                                  refs.add(pergunta.id!);
                                }
                                Quiz novoQuiz = Quiz(
                                    nome: formBuilder.values['nome'],
                                    perguntasReferences: refs);
                                novoQuiz.create();
                                ScaffoldMessenger.maybeOf(context)
                                    ?.showSnackBar(const SnackBar(
                                        content:
                                            Text("Quiz criado com sucesso!")));
                                Navigator.of(context).pop();
                              },
                              child: const Text("Salvar"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: const Text("Quizzes"),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _quizzes.length,
              prototypeItem: ItemQuiz(
                quiz: Quiz(nome: "", perguntasReferences: []),
                modifiable: true,
              ),
              //TODO: atualizar a lista quando der create, update ou delete
              itemBuilder: (context, index) {
                return ItemQuiz(quiz: _quizzes[index]);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.cadastroQuiz);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
