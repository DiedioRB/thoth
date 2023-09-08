import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/helpers/form_builder.dart';

import 'package:thoth/models/pergunta.dart';
import 'package:thoth/components/nossa_snackbar.dart';



class Perguntas extends StatefulWidget {
  const Perguntas({super.key});

  @override
  State<Perguntas> createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {
  //TODO: PLANEJO CARREGAR TODAS AS PERGUNTAS, COLOCAR NESSA LISTA E MOSTRAR
  List<Pergunta> _todasPerguntas = [];
  List<ItemForm> _itemForm = Pergunta.getFields();
  late FormBuilder formBuilder1;
  StreamSubscription? watcher;
  
  @override
  void initState() {
    super.initState();
    formBuilder1 = FormBuilder(Pergunta.getFields()); //?
    
    FirebaseFirestore db = FirebaseFirestore.instance;
    watcher = Pergunta.getCollection(db).snapshots().listen(listen);
  }

  void listen(value) {
    List<Pergunta> perguntas = [];
    if (value.docs.isNotEmpty) {
      for (var perg in value.docs) {
        perguntas.add(perg.data() as Pergunta);
      }
      _todasPerguntas.clear();
      setState(() {
        _todasPerguntas = perguntas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text ("Lista de Todas as perguntas"),
        ),
        body: Column(
          children: [
            formBuilder1.build(),
            FloatingActionButton(
              onPressed: () {
                formBuilder1.addFields(_itemForm);
              },
              child: const Icon(Icons.add),
            ),
          ],
        )
    );
  }
}
