import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/pesquisa.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/components/tutorial.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';

class ItemTopico extends StatefulWidget {
  const ItemTopico(
      {super.key, required this.topico, this.tema, required this.modifiable});

  final Topico topico;
  final Tema? tema;
  final bool modifiable;

  @override
  State<ItemTopico> createState() => _ItemTopicoState();
}

List<bool> exists = [];

class _ItemTopicoState extends State<ItemTopico> with Pesquisa<Pergunta> {
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];
  late Topico topico = widget.topico;

  List<DropdownMenuItem<Tema>> temas = [];
  Tema? tema;

  void _updateModal(context) async {
    FormBuilder form = FormBuilder(Topico.getFields(topico: widget.topico));
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) {
      todasPerguntas.clear();
      for (var pergunta in value.docs) {
        todasPerguntas.add(pergunta.data() as Pergunta);
      }
      todasPerguntas.sort(
        (a, b) => a.pergunta.toLowerCase().compareTo(b.pergunta.toLowerCase()),
      );
      if (mounted) {
        setState(() {
          search(todasPerguntas);
        });
      }
    });
    perguntas = await widget.topico.perguntas;
    await fetchTemas();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            searchController.addListener(() {
              setState(() {
                search(todasPerguntas);
              });
            });
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
                      barraPesquisa(),
                      (itensPesquisa.isEmpty)
                          ? const Text("Nenhum registro encontrado")
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: itensPesquisa.length,
                                  itemBuilder: (context, index) {
                                    Pergunta p = itensPesquisa[index];
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
                              tooltip: "Excluir",
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
    List<Tema> temas = await Tema.tudo();
    this.temas.clear();
    tema = widget.tema;
    for (var tema in temas) {
      this.temas.add(DropdownMenuItem(
            value: tema,
            key: Key(tema.id.toString()),
            child: Text(tema.descricao),
          ));
    }

    setState(() {});
  }

  void modalTutorial(Widget titulo, Widget texto, Color cor,
      Function() callback, bool mostrar) {
    if (mostrar) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: titulo,
              content: texto,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: cor),
                  ),
                ),
                TextButton(
                  onPressed: callback,
                  child: Text("Entendido",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: cor)),
                )
              ],
            );
          });
    } else {
      callback.call();
    }
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
              children: ((widget.tema != null)
                  ? [
                      IconButton(
                          icon: const Icon(
                            Icons.quiz,
                            color: TemaApp.quizPrimary,
                          ),
                          tooltip: "Quizzes",
                          onPressed: () async {
                            modalTutorial(Tutorial.quizTitle, Tutorial.quizText,
                                TemaApp.quizSecondary, () async {
                              await Tutorial.naoMostrarNovamente(
                                  Tutorial.quizKey);
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(Routes.quizzes,
                                  arguments: [
                                    widget.tema,
                                    topico,
                                    widget.modifiable
                                  ]);
                            }, await Tutorial.deveMostrar(Tutorial.quizKey));
                          }),
                      IconButton(
                          icon: const Icon(
                            Icons.collections_bookmark_outlined,
                            color: TemaApp.flashcardPrimary,
                          ),
                          tooltip: "Flashcards",
                          onPressed: () async {
                            modalTutorial(
                                Tutorial.flashcardTitle,
                                Tutorial.flashcardText,
                                TemaApp.flashcardSecondary, () async {
                              await Tutorial.naoMostrarNovamente(
                                  Tutorial.flashcardKey);
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                  Routes.atividadeFlashcard,
                                  arguments: [widget.tema, topico, null]);
                            },
                                await Tutorial.deveMostrar(
                                    Tutorial.flashcardKey));
                          }),
                      IconButton(
                          icon: const Icon(
                            Icons.drive_eta_outlined,
                            color: TemaApp.kartPrimary,
                          ),
                          tooltip: "Kart",
                          onPressed: () async {
                            modalTutorial(Tutorial.kartTitle, Tutorial.kartText,
                                TemaApp.kartSecondary, () async {
                              await Tutorial.naoMostrarNovamente(
                                  Tutorial.kartKey);
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(Routes.kart,
                                  arguments: [widget.tema, topico]);
                            }, await Tutorial.deveMostrar(Tutorial.kartKey));
                          }),
                    ]
                  : [])
                ..addAll((widget.modifiable)
                    ? [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: "Editar",
                            onPressed: () => _updateModal(context)),
                        IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: "Excluir",
                            onPressed: () => _deleteModal(context)),
                      ]
                    : []),
            )
          ],
        ),
      ),
    );
  }
}
