import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/botao.dart';
import 'package:thoth/components/pesquisa.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/tema.dart';

class CadastroTema extends StatefulWidget {
  const CadastroTema({super.key});

  @override
  State<CadastroTema> createState() => CTemasState();
}

class CTemasState extends State<CadastroTema> with Pesquisa<Topico> {
  List<Tema> cTemas = [];
  List<Topico> todosTopicos = [];
  List<Topico> topicos = [];

  Tema novoTema =
      Tema(descricao: "", topicosReferences: [], codigo: "", id: null);
  late FormBuilder formBuilder;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Tema.getFields(tema: novoTema));

    List<Tema> temas = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Tema.getCollection(db).get().then((value) => {
          if (value.docs.isNotEmpty)
            {
              for (var tema in value.docs) {temas.add(tema.data() as Tema)},
              setState(() {
                cTemas = temas;
              })
            }
        });

    searchController.addListener(() {
      setState(() {
        search(todosTopicos);
      });
    });
  }

  void nTema(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Topico.getCollection(db).get().then((value) {
      todosTopicos.clear();
      for (var topico in value.docs) {
        todosTopicos.add(topico.data() as Topico);
      }
      todosTopicos.sort(
        (a, b) =>
            a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()),
      );
      if (mounted) {
        setState(() {
          search(todosTopicos);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    nTema(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Tema"),
      ),
      body: Center(
        child: Column(
          children: [
            formBuilder.build(),
            const Padding(padding: EdgeInsets.only(top: 30)),
            barraPesquisa(),
            (itensPesquisa.isEmpty)
                ? const Text("Nenhum registro encontrado")
                : Expanded(
                    child: ListView.builder(
                        itemCount: itensPesquisa.length,
                        itemBuilder: (context, index) {
                          Topico t = itensPesquisa[index];
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Botao(
                    callback: () async {
                      List<DocumentReference> refs = [];
                      for (var topico in topicos) {
                        refs.add(topico.id!);
                      }
                      Tema novoTema = Tema(
                          descricao: formBuilder.values['nome'],
                          codigo: formBuilder.values['código'],
                          topicosReferences: refs);
                      novoTema.create();
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                              content: Text("Tema criado com sucesso!")));
                      Navigator.of(context).pop();
                    },
                    texto: "Salvar")
              ],
            )
          ],
        ),
      ),
    );
  }
}
