import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/topico.dart';
import 'package:flip_card/flip_card.dart';
import 'package:thoth/tema_app.dart';
import 'dart:math';
import 'dart:async';

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
  String respostaPontos = "";
  String textoBotao = "Próximo";
  late Timer _timer;
  int _segundos = 0;
  //List<String> pontosCard = [];
  bool _verificar = true;



  @override
  void initState() {
    super.initState();
    _getPerguntas();
    _startTimer();
  }

  void _getPerguntas() async {
    if (widget.topico != null) {
      _perguntas = await widget.topico!.perguntas;
    } else {
      _perguntas = await widget.deck!.perguntas;
    }


    if(qtdPerguntas < _perguntas.length) {
      while(perguntasQuiz.length < qtdPerguntas) {
        int indiceAleatorio = aleatorio.nextInt(_perguntas.length);
        Pergunta perguntaSelecionada = _perguntas[indiceAleatorio];
        if(!perguntasQuiz.contains(perguntaSelecionada)) {
          perguntasQuiz.add(perguntaSelecionada);
        }
      }
    } else {
      perguntasQuiz = _perguntas;
    }

    setState(() {});
  }


  void _startTimer() {
    const umSegundo = const Duration(seconds: 1);
    _timer = Timer.periodic(umSegundo, (Timer timer) {
      setState(() {
        _segundos++;
      });
    });
  }

  void _calculaPontos(int secs) {
    if (secs < 3) {
      //pontosCard.add("Muito Bom!");
      respostaPontos = "Muito Bom!";
    } else if (secs < 5) {
      //pontosCard.add("Bom, mas ainda pode melhorar :D");
      respostaPontos = "Bom, mas ainda pode melhorar :D";
    } else {
      //pontosCard.add("É, essa não foi legal. Continue treinando! :D");
      respostaPontos = "É, essa não foi legal. Continue treinando! :D";
    }

    print("segundos: $secs");

  }

  void _attCount() {
    if(count + 1 < perguntasQuiz.length) {
      if (count + 2 == perguntasQuiz.length) {
        textoBotao = "Finalizar";
      }
      count++;
    } else {
      count = count;
    }
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards ${count + 1}/${perguntasQuiz.length}")
      ),
      body:
          perguntasQuiz.isEmpty?
              const Center(
                child: CircularProgressIndicator(),
              ):
      Center(
          child: Column(
            children: [
              Text("TEMPO: $_segundos",
                style: TextStyle(
                    fontSize: 20,
                    color: TemaApp.contrastSecondary
                ),
              ),
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
                      if(!_isCardFlipped) {
                        _calculaPontos(_segundos);
                      }
                      _isCardFlipped = true;
                      resposta = perguntasQuiz[count].resposta;

                    });
                  },
                  front: Container(
                    decoration: BoxDecoration(
                        color: TemaApp.darkSecondary,
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
              _verificar?
              Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: 85,
                  width: 150,
                  decoration: BoxDecoration(
                      color: TemaApp.darkPrimary
                  ),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _timer.cancel();
                          _segundos = 0;
                          //_verificar = false;

                          if(!_isCardFlipped) {
                            respostaPontos = "Errou";
                            _attCount();
                            _isCardFlipped = false;
                            _startTimer();
                            //resposta = perguntasQuiz[count].resposta;
                          } else {
                            _verificar = false;
                          }

                          //if(pontosCard.isEmpty) {
                          //  pontosCard.add("Errou!");
                          //}
                        });
                      },
                      child: const Center(
                        child: Text("Verificar",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                  )
              ):
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  child: Column(
                    children: [
                      Text(respostaPontos),
                      Container(
                          margin: const EdgeInsets.only(top: 50),
                          height: 85,
                          width: 150,
                          decoration: BoxDecoration(
                              color: TemaApp.darkPrimary
                          ),
                          child: InkWell(
                              onTap: () {
                                setState(() {

                                  if (_isCardFlipped && !_verificar) {
                                    cardKey.currentState!.toggleCard();
                                    resposta = "";
                                    _isCardFlipped = false;
                                    _verificar = true;
                                  }

                                  _attCount();

                                  _startTimer();

                                });
                              },
                              child: Center(
                                child: Text(textoBotao,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
