import 'package:flutter/material.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';
import 'package:flip_card/flip_card.dart';
import 'package:thoth/tema_app.dart';
import 'dart:math';

import 'package:thoth/views/pontuacao.dart';

class AtividadeFlashcard extends StatefulWidget {
  final Tema? tema;
  final Topico? topico;
  final Deck? deck;
  const AtividadeFlashcard({super.key, this.tema, this.topico, this.deck});

  @override
  State<AtividadeFlashcard> createState() => _AtividadeFlashcardState();
}

class _AtividadeFlashcardState extends State<AtividadeFlashcard> {
  Atividade? atividade;

  int count = 0;
  bool _isCardFlipped = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String resposta = "";

  @override
  void initState() {
    super.initState();
    carregaAtividade();
  }

  void carregaAtividade() async {
    Tema tema = widget.tema!;
    List<Pergunta> perguntas = await widget.deck?.perguntas ?? [];
    if (perguntas.isNotEmpty) {
      atividade = Atividade(
          tema: tema,
          topico: widget.topico,
          usarPerguntas: perguntas,
          onLoad: () {
            setState(() {});
          });
    } else {
      atividade = Atividade(
          tema: tema,
          topico: widget.topico,
          onLoad: () {
            setState(() {});
          });
    }
  }

  void _registraResposta(int pts) {
    if (atividade != null) {
      cardKey.currentState!.toggleCard();
      resposta = "";
      _isCardFlipped = false;

      if (pts > 0) {
        atividade!.marcarAcerto();
      } else {
        atividade!.marcarErro();
      }
      atividade!.proximaPergunta();

      if (!atividade!.finalizado) {
        count++;
      } else {
        Navigator.of(context).pushNamed(Routes.pontuacao,
            arguments: [atividade, CorPontuacao.flashcards]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Flashcards ${count + 1}/${atividade?.perguntas.length ?? 0}")),
        body: atividade != null && !atividade!.carregado
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : atividade?.perguntas.isEmpty ?? true
                ? const Text("Nenhuma perguntas encontrada")
                : Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          padding: const EdgeInsets.all(25),
                          width: 380,
                          height: 380,
                          child: FlipCard(
                            fill: Fill.fillBack,
                            direction: FlipDirection.HORIZONTAL,
                            side: CardSide.FRONT,
                            flipOnTouch: _isCardFlipped == false,
                            key: cardKey,
                            onFlip: () {
                              setState(() {
                                _isCardFlipped = true;
                                resposta = atividade!.pergunta.resposta;
                              });
                            },
                            front: Container(
                              decoration: BoxDecoration(
                                  color: TemaApp.darkPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0))),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(atividade!.pergunta.pergunta,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )),
                            ),
                            back: Container(
                              decoration: BoxDecoration(
                                  color: TemaApp.lightPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0))),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(resposta,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )),
                            ),
                          ),
                        ),
                        _isCardFlipped
                            ? Expanded(
                                child: SizedBox(
                                  height: double.maxFinite,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Avalie seu desempenho: ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: TemaApp.darkSecondary),
                                        ),
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  height: 60,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          TemaApp.darkPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 2),
                                                        )
                                                      ]),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _registraResposta(0);
                                                        });
                                                      },
                                                      child: const Center(
                                                        child: Text(
                                                          "Errei ;-;",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ))),
                                              Container(
                                                  height: 60,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          TemaApp.darkPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 2),
                                                        )
                                                      ]),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _registraResposta(1);
                                                        });
                                                      },
                                                      child: const Center(
                                                        child: Text(
                                                          "Fui okay",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ))),
                                            ],
                                          )),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  height: 60,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          TemaApp.darkPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 2),
                                                        )
                                                      ]),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _registraResposta(2);
                                                        });
                                                      },
                                                      child: const Center(
                                                        child: Text(
                                                          "Fui bem!",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ))),
                                              Container(
                                                  height: 60,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          TemaApp.darkPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 2),
                                                        )
                                                      ]),
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _registraResposta(3);
                                                        });
                                                      },
                                                      child: const Center(
                                                        child: Text(
                                                          "Foi moleza",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )))
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ));
  }
}
