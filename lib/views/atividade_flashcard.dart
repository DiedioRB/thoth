import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';
import 'package:flip_card/flip_card.dart';
import 'package:thoth/tema_app.dart';
import 'dart:math';


class AtividadeFlashcard extends StatefulWidget {
  final Topico? topico;
  final Deck? deck;
  const AtividadeFlashcard({super.key, this.topico, this.deck});

  @override
  State<AtividadeFlashcard> createState() => _AtividadeFlashcardState();
}

class _AtividadeFlashcardState extends State<AtividadeFlashcard> {
  List<Pergunta> _perguntas = [];
  List<Pergunta> perguntasQuiz = [];
  Random aleatorio = Random();
  int qtdPerguntas = 5;
  int indiceListView = -1;
  int count = 0;
  bool _isCardFlipped = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String resposta = "";
  int pontos = 0;


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    _getPerguntas();

  }

  void _getPerguntas() async {
    if (widget.topico != null) {
      _perguntas = await widget.topico!.perguntas;
    } else {
      _perguntas = await widget.deck!.perguntas;
    }

    if (qtdPerguntas < _perguntas.length) {
      while (perguntasQuiz.length < qtdPerguntas) {
        int indiceAleatorio = aleatorio.nextInt(_perguntas.length);
        Pergunta perguntaSelecionada = _perguntas[indiceAleatorio];
        if (!perguntasQuiz.contains(perguntaSelecionada)) {
          perguntasQuiz.add(perguntaSelecionada);
        }
      }
    } else {
      perguntasQuiz = _perguntas;
    }

    setState(() {});
  }



  void _attCount(int pts) {
    cardKey.currentState!.toggleCard();
    resposta = "";
    _isCardFlipped = false;
    pontos = pontos + pts;

    if(count + 1 < perguntasQuiz.length) {
      count++;
    } else if (count + 1 == perguntasQuiz.length) {
      Navigator.of(context).pushNamed(
          Routes.pontuacao,
          arguments: [pontos, 1]
      );
    } else {
      count = count;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Flashcards ${count + 1}/${perguntasQuiz.length}")),
        body: perguntasQuiz.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              ):
      Center(
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
                      resposta = perguntasQuiz[count].resposta;
                    });
                  },
                  front: Container(
                    decoration: BoxDecoration(
                        color: TemaApp.darkPrimary,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8.0))),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(perguntasQuiz[count].pergunta,
                              style: const TextStyle(color: Colors.white)
                          ),
                        )
                    ),
                  ),
                  back: Container(
                    decoration: BoxDecoration(
                        color: TemaApp.lightPrimary,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8.0))),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(resposta,
                              style: const TextStyle(color: Colors.white)),
                        )
                    ),
                  ),
                ),
              ),
              _isCardFlipped?
              Expanded(
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
                              color: TemaApp.darkSecondary
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 60,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: TemaApp.darkPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        )
                                      ]
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _attCount(0);
                                        });
                                      },
                                      child: const Center(
                                        child: Text("Errei ;-;",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  )
                              ),
                              Container(
                                  height: 60,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: TemaApp.darkPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        )
                                      ]
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _attCount(1);
                                        });
                                      },
                                      child: const Center(
                                        child: Text("Fui okay",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  )
                              ),
                            ],
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 60,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: TemaApp.darkPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        )
                                      ]
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _attCount(2);
                                        });
                                      },
                                      child: const Center(
                                        child: Text("Fui bem!",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  )
                              ),
                              Container(
                                  height: 60,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: TemaApp.darkPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        )
                                      ]
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _attCount(3);
                                        });
                                      },
                                      child: const Center(
                                        child: Text("Foi moleza",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  )
                              )
                            ],
                          )
                      ),

                    ],
                  ),
                ),
              ):
              Container()
            ],
          ),

      )
    );
  }


}
