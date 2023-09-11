import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/models/topico.dart';

class ItemQuiz extends StatefulWidget {
  const ItemQuiz({super.key, required this.quiz, required this.modifiable});

  final Quiz quiz;
  final bool modifiable;

  @override
  State<ItemQuiz> createState() => _ItemQuizState();
}

List<bool> exists = [];

class _ItemQuizState extends State<ItemQuiz> {
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  List<DropdownMenuItem<Topico>> topicos = [];
  Topico? topico;

  void _updateModal(context) async {
    FormBuilder _form = FormBuilder(Quiz.getFields(quiz: widget.quiz));
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
          todasPerguntas.clear(),
          for (var pergunta in value.docs)
            {todasPerguntas.add(pergunta.data() as Pergunta)}
        });
    perguntas = await widget.quiz.perguntas;
    await fetchTopicos();

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
                      DropdownButton<Topico>(
                          disabledHint: const Text("Selecione..."),
                          items: topicos,
                          onChanged: (Topico? topico) {
                            if (topico != null) {
                              setState(() {
                                this.topico = topico;
                              });
                            }
                          },
                          value: topico),
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
                                widget.quiz.topicoReference = topico?.id;
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

  fetchTopicos() async {
    List<Topico> topicos = await Topico.todos();
    topico = null;
    this.topicos.clear();
    for (var topico in topicos) {
      this.topicos.add(DropdownMenuItem(
            value: topico,
            key: Key(topico.id.toString()),
            child: Text(topico.descricao),
          ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.quiz.nome),
      trailing: (widget.modifiable)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _updateModal(context)),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteModal(context)),
              ],
            )
          : null,
    );
  }
}
