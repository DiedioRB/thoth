import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';

class AtividadeQuiz extends StatefulWidget {
  const AtividadeQuiz({super.key});

  @override
  State<AtividadeQuiz> createState() => _AtividadeQuizState();
}

class _AtividadeQuizState extends State<AtividadeQuiz> {
  List<Pergunta> _todasPerguntas = [];
  List<Pergunta> _quizPerguntas = [];
  Random aleatorio = Random();
  Quiz? _quiz = Quiz(nome: "", perguntasReferences: [], id: null, quantidadePerguntas: 5);
  int _count = 0;



  //TODO: A VARIABLE WITH INDEX OF QUESTIONS TO BE ITERATING WITHIN ARRAY

  @override
  void initState() {
    super.initState();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Pergunta.getCollection(db).get().then((value) => {
      if(value.docs.isNotEmpty) {
        for (var pergunta in value.docs) {
          _todasPerguntas.add(pergunta.data() as Pergunta)
        }
      }
    });



  }

  void attCount() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text ("EIS O PODEROSO QUIZ! \\o/"),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: Text("${_count}",
                        style: TextStyle(
                          fontSize: 22.0,
                        ))
                  ),
                  FloatingActionButton.small(
                      onPressed: () {
                        attCount();
                      },
                      child: const Icon(Icons.add)
                  )
                ],
              ),
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
                  child: Text("Pergunta aqui :3",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )),
                ),
              ),
              Divider(height: 25.0),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(top: 8.0),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2.5
                    ),
                    borderRadius: BorderRadius.circular(18.0)
                  ),
                  child: Text("Resposta",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold
                      )),
                )
              ),
              InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black54,
                            width: 2.5
                        ),
                        borderRadius: BorderRadius.circular(18.0)
                    ),
                    child: Text("Resposta",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold
                        )),
                  )
              ),
              InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black54,
                            width: 2.5
                        ),
                        borderRadius: BorderRadius.circular(18.0)
                    ),
                    child: Text("Resposta",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold
                        )),
                  )
              ),
              Divider(height: 25.0),
              ElevatedButton(onPressed: () {}, child: Text("Próximo"))


            ],
          ),
        )
      ),
    );
  }
}