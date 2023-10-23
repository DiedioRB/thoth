import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/routes.dart';

class ItemTema extends StatefulWidget {
  const ItemTema({super.key, required this.tema, required this.modifiable});

  final Tema tema;
  final bool modifiable;

  @override
  State<ItemTema> createState() => _ItemTemaState();
}

List<bool> exists = [];

class _ItemTemaState extends State<ItemTema> {
  List<Topico> todosTopicos = [];
  List<Topico> topicos = [];

  void _updateModal(context) async {
    FormBuilder form = FormBuilder(Tema.getFields(tema: widget.tema));
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Topico.getCollection(db).get().then((value) => {
          todosTopicos.clear(),
          for (var topico in value.docs)
            {todosTopicos.add(topico.data() as Topico)}
        });
    topicos = await widget.tema.topicos;

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
                      Expanded(
                        child: ListView.builder(
                            itemCount: todosTopicos.length,
                            itemBuilder: (context, index) {
                              Topico t = todosTopicos[index];
                              return CheckboxListTile(
                                title: Text(t.descricao),
                                value: topicos.any(
                                  (element) => element.id == t.id,
                                ),
                                onChanged: (value) => {
                                  setState(() {
                                    if (value == false) {
                                      topicos.removeWhere((element) {
                                        return element.id == t.id;
                                      });
                                    } else {
                                      topicos.add(t);
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
                                widget.tema.descricao = form.values['nome'];
                                widget.tema.atualizaReferencias(topicos);
                                widget.tema.update();
                                ScaffoldMessenger.maybeOf(context)
                                    ?.showSnackBar(const SnackBar(
                                        content: Text(
                                            "Tema atualizado com sucesso!")));
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
          title: const Text("Excluir tema?"),
          content: const Text("Isso irá remover o tema do sistema!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Não")),
            TextButton(
                onPressed: () {
                  widget.tema.delete();
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      const SnackBar(
                          content: Text("Tema excluído com sucesso!")));
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
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.topicos,
              arguments: [widget.tema, widget.modifiable]);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.tema.descricao),
              if (widget.modifiable)
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.featured_play_list),
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.flashcards,
                              arguments: widget.tema);
                        }),
                    IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: "Adicionar perguntas",
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              Routes.cadastroPerguntas,
                              arguments: widget.tema);
                        }),
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _updateModal(context)),
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
  }
}
