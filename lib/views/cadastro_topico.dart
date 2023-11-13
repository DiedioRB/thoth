import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/botao.dart';
import 'package:thoth/components/pesquisa.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';

class CadastroTopico extends StatefulWidget {
  const CadastroTopico({super.key});

  @override
  State<CadastroTopico> createState() => CTopicosState();
}

class CTopicosState extends State<CadastroTopico> with Pesquisa<Pergunta> {
  List<Topico> cTopicos = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  List<DropdownMenuItem<Tema>> temas = [];
  Tema? tema;

  Topico novoTopico = Topico(descricao: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Topico.getFields(topico: novoTopico));

    List<Topico> topicos = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Topico.getCollection(db).get().then((value) {
      if (value.docs.isNotEmpty) {
        for (var topico in value.docs) {
          topicos.add(topico.data() as Topico);
        }
        if (mounted) {
          setState(() {
            cTopicos = topicos;
          });
        }
      }
    });

    fetchTemas();

    searchController.addListener(() {
      setState(() {
        search(todasPerguntas);
      });
    });
  }

  fetchTemas() async {
    List<Tema> temas = await Tema.tudo();
    this.temas.clear();
    for (var tema in temas) {
      this.temas.add(DropdownMenuItem(
            value: tema,
            key: Key(tema.id.toString()),
            child: Text(tema.descricao),
          ));
    }
    this.temas.sort(
          (DropdownMenuItem<Tema> a, DropdownMenuItem<Tema> b) => a
              .value!.descricao
              .toLowerCase()
              .compareTo(b.value!.descricao.toLowerCase()),
        );
    if (mounted) {
      setState(() {
        tema = temas[0];
      });
    }
  }

  void nTopico(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) {
      todasPerguntas.clear();
      for (var pergunta in value.docs) {
        todasPerguntas.add(pergunta.data() as Pergunta);
      }
      todasPerguntas.sort((a, b) =>
          a.pergunta.toLowerCase().compareTo(b.pergunta.toLowerCase()));
      if (mounted) {
        setState(() {
          search(todasPerguntas);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    nTopico(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Topico"),
      ),
      body: Center(
        child: Column(
          children: [
            formBuilder.build(),
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
            Expanded(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Botao(
                  callback: () async {
                    List<DocumentReference> refs = [];
                    for (var pergunta in perguntas) {
                      refs.add(pergunta.id!);
                    }
                    Topico novoTopico = Topico(
                        descricao: formBuilder.values['nome'],
                        perguntasReferences: refs,
                        temaReference: tema?.id);
                    novoTopico.create();
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(
                            content: Text("Topico criado com sucesso!")));
                    Navigator.of(context).pop();
                  },
                  texto: "Salvar",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
