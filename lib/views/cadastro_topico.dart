import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/topico.dart';

class CadastroTopico extends StatefulWidget {
  const CadastroTopico({super.key});

  @override
  State<CadastroTopico> createState() => CTopicosState();
}

class CTopicosState extends State<CadastroTopico> {
  List<Topico> cTopicos = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  Topico novoTopico = Topico(descricao: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Topico.getFields(topico: novoTopico));

    List<Topico> topicos = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Topico.getCollection(db).get().then((value) => {
          if (value.docs.isNotEmpty)
            {
              for (var topico in value.docs)
                {topicos.add(topico.data() as Topico)},
              setState(() {
                cTopicos = topicos;
              })
            }
        });
  }

  void nTopico(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
          todasPerguntas.clear(),
          for (var pergunta in value.docs)
            {todasPerguntas.add(pergunta.data() as Pergunta)}
        });
  }

  @override
  Widget build(BuildContext context) {
    nTopico(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Criar Topico"),
      ),
      body: Center(
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
                      List<DocumentReference> refs = [];
                      for (var pergunta in perguntas) {
                        refs.add(pergunta.id!);
                      }
                      Topico novoTopico = Topico(
                          descricao: formBuilder.values['nome'],
                          perguntasReferences: refs);
                      novoTopico.create();
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                              content: Text("Topico criado com sucesso!")));
                      Navigator.of(context).pop();
                    },
                    child: const Text("Salvar"))
              ],
            )
          ],
        ),
      ),
    );
  }
}