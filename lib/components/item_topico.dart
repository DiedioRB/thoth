import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';

class ItemTopico extends StatefulWidget {
  const ItemTopico({super.key, required this.topico, required this.modifiable});

  final Topico topico;
  final bool modifiable;

  @override
  State<ItemTopico> createState() => _ItemTopicoState();
}

List<bool> exists = [];

class _ItemTopicoState extends State<ItemTopico> {
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  List<DropdownMenuItem<Tema>> temas = [];
  Tema? tema;

  void _updateModal(context) async {
    FormBuilder form = FormBuilder(Topico.getFields(topico: widget.topico));
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
          todasPerguntas.clear(),
          for (var pergunta in value.docs)
            {todasPerguntas.add(pergunta.data() as Pergunta)}
        });
    perguntas = await widget.topico.perguntas;
    await fetchTemas();

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
                      form.build(),
                      DropdownButton<Tema>(
                          disabledHint: const Text("Selecione..."),
                          items: temas,
                          onChanged: (Tema? tema) {
                            if (tema != null) {
                              setState(() {
                                this.tema = tema;
                              });
                            }
                          },
                          value: tema),
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
                                widget.topico.descricao = form.values['nome'];
                                widget.topico.temaReference = tema?.id;
                                widget.topico.atualizaReferencias(perguntas);
                                widget.topico.update();
                                ScaffoldMessenger.maybeOf(context)
                                    ?.showSnackBar(const SnackBar(
                                        content: Text(
                                            "Topico atualizado com sucesso!")));
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
          title: const Text("Excluir topico?"),
          content: const Text("Isso irá remover o topico do sistopico!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Não")),
            TextButton(
                onPressed: () {
                  widget.topico.delete();
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      const SnackBar(
                          content: Text("Topico excluído com sucesso!")));
                  Navigator.of(context).pop();
                },
                child: const Text("Sim")),
          ],
        );
      },
    );
  }

  fetchTemas() async {
    List<Tema> temas = await Tema.todos();
    tema = null;
    this.temas.clear();
    for (var tema in temas) {
      this.temas.add(DropdownMenuItem(
            value: tema,
            key: Key(tema.id.toString()),
            child: Text(tema.descricao),
          ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.topico.descricao),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    icon: const Icon(Icons.quiz),
                    tooltip: "Quizzes",
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(Routes.quizzes, arguments: widget.topico);
                    }),
                IconButton(
                    icon: const Icon(Icons.collections_bookmark_outlined),
                    tooltip: "Flashcards",
                    onPressed: () async {
                      Navigator.of(context).pushNamed(Routes.atividadeFlashcard,
                          arguments: [await widget.topico, null]);
                    }),
                IconButton(
                    icon: const Icon(Icons.drive_eta_outlined),
                    tooltip: "Kart",
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.kart);
                    }),
                if (widget.modifiable) ...[
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _updateModal(context)),
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteModal(context)),
                ]
              ],
            )
          ],
        ),
      ),
    );
    // return ListTile(
    //   title: Text(widget.topico.descricao),
    //   trailing: (widget.modifiable)
    //       ? Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             IconButton(
    //                 icon: const Icon(Icons.edit),
    //                 onPressed: () => _updateModal(context)),
    //             IconButton(
    //                 icon: const Icon(Icons.delete),
    //                 onPressed: () => _deleteModal(context)),
    //           ],
    //         )
    //       : null,
    //   enabled: true,
    //   onTap: () {
    //     Navigator.of(context)
    //         .pushNamed(Routes.quizzes, arguments: widget.topico);
    //   },
    // );
  }
}
