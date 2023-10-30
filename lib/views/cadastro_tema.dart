import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/tema.dart';

class CadastroTema extends StatefulWidget {
  const CadastroTema({super.key});

  @override
  State<CadastroTema> createState() => CTemasState();
}

class CTemasState extends State<CadastroTema> {
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
  }

  void nTema(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Topico.getCollection(db).get().then((value) => {
          todosTopicos.clear(),
          for (var topico in value.docs)
            {todosTopicos.add(topico.data() as Topico)}
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
                    child: const Text("Salvar"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
