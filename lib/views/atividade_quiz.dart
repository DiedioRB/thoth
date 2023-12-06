import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thoth/components/atividades.dart';
import 'package:thoth/components/botao.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/views/pontuacao.dart';

class AtividadeQuiz extends StatefulWidget {
  final Tema tema;
  final List<Pergunta> perguntas;
  const AtividadeQuiz(
      {super.key, required this.tema, this.perguntas = const []});

  @override
  State<AtividadeQuiz> createState() => _AtividadeQuizState();
}

class _AtividadeQuizState extends State<AtividadeQuiz> {
  late Atividade atividade;

  Color cor = Colors.transparent;
  int count = 0;
  int indiceListView = -1;
  int pontos = 0;
  bool acertou = false;

  @override
  void initState() {
    super.initState();
    carregaAtividade();
  }

  void carregaAtividade() async {
    atividade = Atividade(tema: widget.tema, usarPerguntas: widget.perguntas);
  }

  void _registraResposta() {
    indiceListView = -1;
    acertou = false;
    count++;
    if (!atividade.finalizado) {
      setState(() {
        atividade.proximaPergunta();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: TemaApp.quizPrimary,
            title: Text("Quiz: ${count + 1} / ${atividade.perguntas.length}")),
        body: !atividade.carregado
            ? const Center(child: CircularProgressIndicator())
            : atividade.perguntas.isEmpty
                ? const Text("Nenhuma perguntas encontrada")
                : Center(
                    child: Container(
                      margin: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 150,
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            decoration: BoxDecoration(
                                color: TemaApp
                                    .quizSecondary, //verify use of Colors.transparent
                                borderRadius: BorderRadius.circular(18)),
                            child: Center(
                              child: Text(
                                atividade.pergunta.pergunta,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: TemaApp.branco,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Divider(height: 25, color: TemaApp.quizPrimary),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: atividade.pergunta.respostas.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    indiceListView = index;
                                    cor = TemaApp.quizTertiary;
                                  });
                                  if (atividade.pergunta.respostaCorreta ==
                                      index) {
                                    acertou = true;
                                  } else {
                                    acertou = false;
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 18),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black54, width: 2.5),
                                      borderRadius: BorderRadius.circular(18),
                                      color: index == indiceListView
                                          ? cor
                                          : Colors.transparent),
                                  child: Text(
                                    atividade.pergunta.respostas[index],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(height: 25, color: TemaApp.quizPrimary),
                          Botao(
                              texto: (count + 1) < atividade.perguntas.length
                                  ? "Próximo"
                                  : "Finalizar",
                              corFundo: TemaApp.quizPrimary,
                              corTexto: TemaApp.branco,
                              callback: () {
                                setState(() {
                                  if (acertou) {
                                    atividade.marcarAcerto();
                                  } else {
                                    atividade.marcarErro();
                                  }
                                });
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: acertou
                                            ? Text("ACERTOU!",
                                                style: TextStyle(
                                                    color:
                                                        TemaApp.quizSecondary))
                                            : Text("ERROU!",
                                                style: TextStyle(
                                                    color:
                                                        TemaApp.quizSecondary)),
                                        content: acertou
                                            ? Text(
                                                "Parabéns! Continue estudando!",
                                                style: TextStyle(
                                                    color:
                                                        TemaApp.quizSecondary))
                                            : Text(
                                                "Poxa, que pena. A resposta correta era: \n"
                                                "${atividade.pergunta.respostas[atividade.pergunta.respostaCorreta]}",
                                                style: TextStyle(
                                                    color:
                                                        TemaApp.quizSecondary)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _registraResposta();
                                              if (atividade.finalizado) {
                                                Navigator.of(context).pushNamed(
                                                    Routes.pontuacao,
                                                    arguments: [
                                                      atividade,
                                                      CorPontuacao.quiz
                                                    ]);
                                              }
                                            },
                                            child: Text("Entendido",
                                                style: TextStyle(
                                                    color:
                                                        TemaApp.quizSecondary,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      );
                                    });
                              })
                        ],
                      ),
                    ),
                  ));
  }

  //something
  // TODO: SOMETHING
}
