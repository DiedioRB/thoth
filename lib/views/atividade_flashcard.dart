import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:flip_card/flip_card.dart';
import 'package:thoth/tema_app.dart';
import 'dart:math';

class AtividadeFlashcard extends StatefulWidget {
  final Deck deck;
  AtividadeFlashcard({super.key, required this.deck});

  @override
  State<AtividadeFlashcard> createState() => _AtividadeFlashcardState();
}

class _AtividadeFlashcardState extends State<AtividadeFlashcard> {
  Deck? _deck;
  List<Pergunta> _perguntas = [];
  List<Pergunta> perguntasQuiz = [];
  Random aleatorio = Random();
  int qtdPerguntas = 5;
  int indiceListView = -1;
  int count = 0;
  bool _isCardFlipped = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String resposta = "";
  String textoBotao = "Próximo";



  @override
  void initState() {
    super.initState();
    _deck = widget.deck;
    _getPerguntas();

  }

  void _getPerguntas() async {
    _perguntas = await _deck!.perguntas;

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
            Container(
                margin: const EdgeInsets.only(top: 100),
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
            Container(
              margin: const EdgeInsets.only(top: 50),
              height: 85,
              width: 225,
              decoration: BoxDecoration(
                color: TemaApp.darkPrimary
              ),
              child: InkWell(
                onTap: () {
                  setState(() {

                    if (_isCardFlipped) {
                      cardKey.currentState!.toggleCard();
                      resposta = "";
                      _isCardFlipped = false;
                    }

                    if(count + 1 < perguntasQuiz.length) {
                      if (count + 2 == perguntasQuiz.length) {
                        textoBotao = "Finalizar";
                      }
                      count++;
                    } else {
                      count = count;
                    }

                  });
                },
                child: Center(
                  child: Text(textoBotao,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              )
            )
          ],
        ),
      )
    );
  }
}
