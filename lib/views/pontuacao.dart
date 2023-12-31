import 'package:flutter/material.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/components/botao.dart';

enum CorPontuacao { quiz, flashcards, kart }

class Pontuacao extends StatefulWidget {
  //cores de temas:
  //0 - quizz
  //1 - flashcard
  //2 - kart
  final CorPontuacao cor;
  final Atividade atividade;
  const Pontuacao({super.key, required this.atividade, required this.cor});

  @override
  State<Pontuacao> createState() => _PontuacaoState();
}

class _PontuacaoState extends State<Pontuacao> {
  Color corPrimaria = Colors.transparent;
  Color corSecundaria = Colors.transparent;

  @override
  void initState() {
    super.initState();
    if (widget.cor == CorPontuacao.quiz) {
      corPrimaria = TemaApp.quizPrimary;
      corSecundaria = TemaApp.quizSecondary;
    } else if (widget.cor == CorPontuacao.flashcards) {
      corPrimaria = TemaApp.flashcardPrimary;
      corSecundaria = TemaApp.flashcardSecondary;
    } else if (widget.cor == CorPontuacao.kart) {
      corPrimaria = TemaApp.kartPrimary;
      corSecundaria = TemaApp.kartSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: corPrimaria,
          title: const Text("Pontuação")),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25.0),
              child: Text(
                "Parabéns!",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: corSecundaria),
              ),
            ),
            Text(
              "Você fez:",
              style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  color: corSecundaria),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Text(
                "${widget.atividade.acertos}",
                style: TextStyle(
                    fontSize: 55.0,
                    fontWeight: FontWeight.bold,
                    color: corSecundaria),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 50.0),
              child: Text(
                "Pontos!",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: corSecundaria),
              ),
            ),
            Botao(
                texto: "Menu Principal",
                corFundo: corPrimaria,
                corTexto: TemaApp.branco,
                callback: () {
                  Navigator.of(context).pushNamed("/menu");
                })
          ],
        ),
      ),
    );
  }
}
