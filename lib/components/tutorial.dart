import 'package:flutter/material.dart';
import 'package:thoth/tema_app.dart';

class Tutorial {
  static Widget quizzTitle = Container(
      child: Text("O quizz",
        style: TextStyle(
            color: TemaApp.quizPrimary,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),
      ),
  );

  static Widget quizzText = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Text("O que é?",
            style: TextStyle(
                color: TemaApp.quizSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        Text(
            "O quizz é uma atividade recreativa que inspira a aprender através de perguntas e respostas (...)",
            style: TextStyle(
              color: TemaApp.quizSecondary,
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 4),
          child: Text("Como funciona?",
            style: TextStyle(
              color: TemaApp.quizSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          )
        ),
        const Divider(),
        Text(
          "Para realizar o quizz, primeiro selecione um dos quizzes a seguir, orientados dentro do seu tópico de estudo.\n"
              "Em seguida, aparecerá uma pergunta na tela, selecione a resposta correta (...)",
            style: TextStyle(
              color: TemaApp.quizSecondary,
            )
        )
      ],
    ),
  );


  static Widget flashcardTitle = Container(
    child: Text("Flashcards",
      style: TextStyle(
          color: TemaApp.flashcardPrimary,
          fontSize: 30,
          fontWeight: FontWeight.bold
      ),
    ),
  );

  static Widget flashcardText = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Text("O que é?",
            style: TextStyle(
                color: TemaApp.flashcardSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        Text(
            "O flashcard é uma atividade de memorização (...)",
          style: TextStyle(
              color: TemaApp.flashcardSecondary,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text("Como funciona?",
                style: TextStyle(
                    color: TemaApp.flashcardSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            )
        ),
        const Divider(),
        Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque pulvinar ligula a tincidunt. Class. (...)",
            style: TextStyle(
              color: TemaApp.flashcardSecondary,
            )
        )
      ],
    ),
  );


  static Widget kartTitle = Container(
    child: Text("Kart",
      style: TextStyle(
          color: TemaApp.kartPrimary,
          fontSize: 30,
          fontWeight: FontWeight.bold
      ),
    ),
  );

  static Widget kartText = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Text("O que é?",
            style: TextStyle(
                color: TemaApp.kartSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        Text(
            "O quizz é uma atividade recreativa que inspira a aprender através de perguntas e respostas (...)",
            style: TextStyle(
              color: TemaApp.kartSecondary,
            )
        ),
        Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text("Como funciona?",
                style: TextStyle(
                    color: TemaApp.kartSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            )
        ),
        const Divider(),
        Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque pulvinar ligula a tincidunt. Class. (...)",
            style: TextStyle(
              color: TemaApp.kartSecondary,
            )
        )
      ],
    ),
  );


}