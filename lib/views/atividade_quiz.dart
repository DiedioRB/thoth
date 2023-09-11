import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/routes.dart';

class AtividadeQuiz extends StatefulWidget {
  const AtividadeQuiz({super.key});

  @override
  State<AtividadeQuiz> createState() => _AtividadeQuizState();
}

class _AtividadeQuizState extends State<AtividadeQuiz> {
  List<Pergunta> _todasPerguntas = [];
  List<Pergunta> _perguntasQuiz = [];
  Random aleatorio = Random();
  int _qtdPerguntas = 5;
  int _count = 0;
  int _color = 0x00ffffff;
  int _indiceListView = -1;
  Color _cor = Colors.transparent;

  int _pontos = 0;
  bool _acertou = false;




  //TODO: A VARIABLE WITH INDEX OF QUESTIONS TO BE ITERATING WITHIN ARRAY

  @override
  void initState() {
    super.initState();

    _updatePerguntasQuiz();



  }

  void _updatePerguntasQuiz() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) => {
      _todasPerguntas.clear(),
      for (var pergunta in value.docs) {
        _todasPerguntas.add(pergunta.data() as Pergunta)
      }
    });

    if(_qtdPerguntas <= _todasPerguntas.length) {
      while(_perguntasQuiz.length < _qtdPerguntas) {
        int indiceAleatorio = aleatorio.nextInt(_todasPerguntas.length);
        Pergunta perguntaSelecionada = _todasPerguntas[indiceAleatorio];
        if(!_perguntasQuiz.contains(perguntaSelecionada)) {
          _perguntasQuiz.add(perguntaSelecionada);
        }
      }
    }

    setState(() {});

    print(_perguntasQuiz);
  }

  void attCount() {
    _indiceListView = -1;
    setState(() {
      if ((_count + 1) < _perguntasQuiz.length){
        _count++;
      } else {
        _count = _count;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text ("Quiz: ${_count} / ${_perguntasQuiz.length}"),
      ),
      body:
      _perguntasQuiz.isEmpty?
          Center(
            child: CircularProgressIndicator(),
          )

      : Center(
        child: Container(
          margin: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150.0,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Color(0x7f0193F4),
                  borderRadius: BorderRadius.circular(18.0)
                ),
                child: Center(
                  child: Text("${_perguntasQuiz[_count].pergunta}",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )),
                ),
              ),
              Divider(height: 25.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _perguntasQuiz[_count].respostas.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                         _indiceListView = index;
                         _cor = Colors.black26;
                        });

                        if(_perguntasQuiz[_count].respostaCorreta == index) {
                          _acertou = true;
                        } else {
                          _acertou = false;
                        }

                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 8.0),
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black54,
                                width: 2.5
                            ),
                            borderRadius: BorderRadius.circular(18.0),
                          color: index == _indiceListView? _cor : Colors.transparent
                        ),
                        child: Text("${_perguntasQuiz[_count].respostas[index]}",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            )),
                      )
                  );
                }

              ),
              Divider(height: 25.0),
              (_count +1) < _perguntasQuiz.length?
              ElevatedButton(
                  onPressed: () {
                    if(_acertou) {
                      setState(() {
                        _pontos ++;
                      });
                      print(_pontos);
                    }
                    attCount();
                  },
                  child: Text("Próximo")
              ):
                  ElevatedButton(
                      onPressed: () {
                        if(_acertou) {
                          setState(() {
                            _pontos ++;
                          });
                          print(_pontos);
                        }

                        Navigator.of(context).pushNamed(
                            Routes.pontuacaoQuiz,
                        arguments: _pontos);
                      },
                      child: Text("Finalizar"))
            ],
          ),
        )
      ),
    );
  }
}