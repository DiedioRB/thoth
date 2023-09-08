import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/routes.dart';

class ItemQuiz extends StatefulWidget {
  ItemQuiz({super.key, required this.quiz, this.modifiable = false});

  final Quiz quiz;
  bool modifiable;

  @override
  State<ItemQuiz> createState() => _ItemQuizState();
}

List<bool> exists = [];

class _ItemQuizState extends State<ItemQuiz> {
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  void _updateModal(context) async {
    FormBuilder _form = FormBuilder(Quiz.getFields(quiz: widget.quiz));
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
          todasPerguntas.clear(),
          for (var pergunta in value.docs)
            {todasPerguntas.add(pergunta.data() as Pergunta)}
        });
    perguntas = await widget.quiz.perguntas;

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
                      _form.build(),
                      Expanded(
                        child: ListView.builder(
                            itemCount: todasPerguntas.length,
                            itemBuilder: (context, index) {
                              Pergunta p = todasPerguntas[index];
                              return CheckboxListTile(
                                title: Text(p.pergunta),
                                value: perguntas.any(
                                  (element) => element.id == p.id,
                                ),
                                onChanged: (value) => {
                                  setState(() {
                                    if (value == false) {
                                      perguntas.removeWhere((element) {
                                        return element.id == p.id;
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
                                widget.quiz.nome = _form.values['nome'];
                                // widget.quiz.nome = _form.values['nome'];
                                widget.quiz.atualizaReferencias(perguntas);
                                widget.quiz.update();
                                ScaffoldMessenger.maybeOf(context)
                                    ?.showSnackBar(const SnackBar(
                                        content: Text(
                                            "Quiz atualizado com sucesso!")));
                                Navigator.of(context).pop();
                              },
                              child: const Text("Salvar")),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteModal(context)),
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

  void _deleteModal(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir quiz?"),
          content: const Text("Isso irá remover o quiz do sistema!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Não")),
            TextButton(
                onPressed: () {
                  widget.quiz.delete();
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      const SnackBar(
                          content: Text("Quiz excluído com sucesso!")));
                  Navigator.of(context).pop();
                },
                child: const Text("Sim")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.quiz.nome),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _updateModal(context)),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteModal(context)),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(Routes.perguntas);
      }
    );
  }
}
