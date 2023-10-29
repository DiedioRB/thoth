import 'package:flutter/material.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/components/botao.dart';
import 'dart:math';

class Atividade extends StatefulWidget {
  final List<Pergunta> perguntas;
  const Atividade({super.key, required this.perguntas});

  @override
  State<Atividade> createState() => _AtividadeState();
}

class _AtividadeState extends State<Atividade> {
  List<Pergunta> _todasPerguntas = [];
  List<Pergunta> perguntasQuiz = [];
  Random aleatorio = Random();
  Color cor = Colors.transparent;
  int qtdPerguntas = 5;
  int count = 0;
  int indiceListView = -1;
  int pontos = 0;
  bool acertou = false;

  @override
  void initState() {
    super.initState();

    updatePerguntasQuiz();

  }

  void updatePerguntasQuiz() async {
    _todasPerguntas = widget.perguntas;

    if(qtdPerguntas < _todasPerguntas.length) {
      while(perguntasQuiz.length < qtdPerguntas) {
        int indiceAleatorio = aleatorio.nextInt(_todasPerguntas.length);
        Pergunta perguntaSelecionada = _todasPerguntas[indiceAleatorio];
        if(!perguntasQuiz.contains(perguntaSelecionada)) {
          perguntasQuiz.add(perguntaSelecionada);
        }
      }
    } else {
      perguntasQuiz = _todasPerguntas;
    }

    setState(() {});
  }

  void attCount() {
    indiceListView = -1;
    setState(() {
      if((count + 1) < perguntasQuiz.length) {
        count++;
      } else {
        count = count;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TemaApp.quizPrimary,
        title: Text("Quiz: $count / ${perguntasQuiz.length}")
      ),
      body:
        perguntasQuiz.isEmpty?
        const Center(
            child: CircularProgressIndicator()
        ) :
        Center(
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                      color: TemaApp.quizSecondary, //verify use of Colors.transparent
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Center(
                    child: Text(perguntasQuiz[count].pergunta,
                      style: TextStyle(
                          fontSize: 18,
                          color: TemaApp.branco,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Divider(height: 25, color: TemaApp.quizPrimary),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: perguntasQuiz[count].respostas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          indiceListView = index;
                          cor = TemaApp.quizTerciary;
                        });
                        if(perguntasQuiz[count].respostaCorreta == index) {
                          acertou = true;
                        } else {
                          acertou = false;
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black54,
                                width: 2.5
                            ),
                            borderRadius: BorderRadius.circular(18),
                            color: index == indiceListView? cor : Colors.transparent
                        ),
                        child: Text(perguntasQuiz[count].respostas[index],
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    );
                    },
                ),
                Divider(height: 25, color: TemaApp.quizPrimary),
                (count + 1) <  perguntasQuiz.length?
                Botao(
                    texto: "Próximo",
                    corFundo: TemaApp.quizPrimary,
                    corTexto: TemaApp.branco,
                    callback:() {
                      if(acertou) {
                        setState(() {
                          pontos++;
                        });
                      }
                      attCount();
                    })
              : Botao(
                    texto: "Finalizar",
                    corFundo: TemaApp.quizPrimary,
                    corTexto: TemaApp.branco,
                    callback: () {
                      if(acertou) {
                        setState(() {
                          pontos++;
                        });
                      }

                      Navigator.of(context).pushNamed(
                          Routes.pontuacao,
                          arguments: pontos
                      );
                    })

              ],
            ),
          ),
        )
    );
  }
}

