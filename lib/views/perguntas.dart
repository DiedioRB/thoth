import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/routes.dart';



class Perguntas extends StatefulWidget {
  const Perguntas({super.key});

  @override
  State<Perguntas> createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {
  //TODO: PEGAR AS RESPECTIVAS PERGUNTAS DE CADA QUIZ: Necessita link
  //TODO: PEGAR ESSAS PERGUNTAS E COLOCAR NUMA LISTA TOTAL: Done!
  //TODO: PEGAR ALGUMAS DESSAS PERGUNTAS E COLOCAR NUMA LISTA PARA O QUIZ: Done!
  //TODO: PEGAR A PRIMEIRA PEGUNTA DA LISTA PARA QUIZ E MOSTRAR NA TELA, A PERGUNTA E SUAS RESPOSTAS
  //TODO: VERIFICAR RESPOSTA CERTA/ERRADA
  //TODO: IMPLEMENTAR LÓGICA DE REPETIR ESSE PROCESSO ATÉ AS PERGUNTAS ACABAREM
  //TODO: IMPLEMENTAR PONTUAÇÃO
  //TODO: ESTILIZAR
  List<Pergunta> _todasPerguntas = [];
  List<Pergunta> _perguntasQuiz = [];
  int _qtdPerguntas = 5; //Quantidade de perguntas por quiz
  late FormBuilder formBuilder1;
  StreamSubscription? watcher;

  Random rand = Random();

  
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
      _perguntasQuiz.clear();
      setState(() {
        _todasPerguntas = perguntas;

        //Não sei se deveria ficar no setState.
        if (_qtdPerguntas <= _todasPerguntas.length) {
          while(_perguntasQuiz.length < _qtdPerguntas) {
            int randIndex = rand.nextInt(_todasPerguntas.length);
            Pergunta perguntaEscolhida = _todasPerguntas[randIndex];
            if(!_perguntasQuiz.contains(perguntaEscolhida)) {
              _perguntasQuiz.add(perguntaEscolhida);
            }
          }
        } else {
          print("erro de que tamanho de lista");
        }
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
        body: Center(
          child:  ListView.builder(
              itemCount: _perguntasQuiz.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${_perguntasQuiz[index].pergunta}'),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.atividadeQuiz);
                  },
                );
              }
          ),

        )
    );
  }
}
