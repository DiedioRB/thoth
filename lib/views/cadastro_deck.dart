import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/helpers/form_builder.dart';

class CadastroDeck extends StatefulWidget {
  const CadastroDeck({super.key});

  @override
  State<CadastroDeck> createState() => CDeckState();
}

class CDeckState extends State<CadastroDeck> {
  List<Deck> cDecks = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  List<DropdownMenuItem<Topico>> topicos = [];
  Topico? topico;

  Deck novoDeck = Deck(nome: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Deck.getFields(deck: novoDeck));

    List<Deck> decks = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Deck.getCollection(db).get().then((value) => {
      if(value.docs.isNotEmpty) {
        for(var deck in value.docs) {
          decks.add(deck.data() as Deck)
        },

        setState(() {
          cDecks = decks;
        })
      }
    });

    fetchTopicos();
  }

  fetchTopicos() async {
    List<Topico> topicos = await Topico.todos();
    this.topicos.clear();
    for(var topico in topicos) {
      this.topicos.add(DropdownMenuItem(
          value: topico,
          key: Key(topico.id.toString()),
          child: Text(topico.descricao))
      );
    }
    setState(() {
      topico = topicos[0];
    });
  }

  void nDeck(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
      todasPerguntas.clear(),
      for(var pergunta in value.docs) {
        todasPerguntas.add(pergunta.data() as Pergunta)
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    nDeck(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Deck"),
      ),
      body: Center(
          child: Column(
            children: [
              formBuilder.build(),
              DropdownButton<Topico>(
                  disabledHint: const Text("Selecione..."),
                  items: topicos,
                  onChanged: (Topico? topico) {
                    if(topico != null) {
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
                                if(value == false) {
                                  perguntas.removeWhere((element) {
                                    return element.id == p.id;
                                  });
                                } else {
                                  perguntas.add(p);
                                }
                              })
                            },
                        );
                      })
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      List<DocumentReference> refs = [];
                      for(var pergunta in perguntas) {
                        refs.add(pergunta.id!);
                      }
                      Deck novoDeck = Deck(
                        nome: formBuilder.values['nome'],
                        perguntasReferences: refs,
                        topicoReference: topico?.id);
                      novoDeck.create();
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(
                            content: Text("Deck criado com sucesso!")
                        )
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("Salvar")
                  )
                ],
              )
            ],
          )
      )
    );
  }
}
