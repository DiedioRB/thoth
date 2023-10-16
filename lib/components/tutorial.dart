import 'package:flutter/material.dart';
import 'package:thoth/tema_app.dart';

class Tutorial {
  static Widget quizzTitle = Container(
      child: Text("O quizz",
        style: TextStyle(
            color: TemaApp.darkPrimary,
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
          child: Text("Instruções de uso",
            style: TextStyle(
                color: TemaApp.darkPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        const Text(
            "Essa atividade consiste em responder as perguntas conforme elas aparecem na tela. \n"
                "Ao entrar na atividade, você verá uma pergunta, seguida por múltiplas respostas. \n"
                "Sempre haverá uma resposta verdadeira, sendo todas as outras falsas. \n"


        ),
      ],
    ),
  );

  /*
  *  static Widget quizzText = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Text("O que é?",
            style: TextStyle(
                color: TemaApp.darkPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        const Text(
            "O quizz é uma atividade recreativa que inspira a aprender através de perguntas e respostas (...)"
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 4),
          child: Text("Como funciona?",
            style: TextStyle(
              color: TemaApp.darkPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          )
        ),
        const Divider(),
        const Text(
          "Para realizar o quizz, primeiro selecione um dos quizzes a seguir, orientados dentro do seu tópico de estudo.\n"
              "Em seguida, aparecerá uma pergunta na tela, selecione a resposta correta (...)"
        )
      ],
    ),
  );
  *
  *
  *
  * */



  static Widget flashcardTitle = Container(
    child: Text("Flashcards",
      style: TextStyle(
          color: TemaApp.darkPrimary,
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
          child: Text("Instruções de uso",
            style: TextStyle(
                color: TemaApp.darkPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        const Text(
            "Ao iniciar a atividade, você verá um card com uma pergunta. \n"
                "Tente se lembrar da resposta e então, toque no card para virá-lo. \n"
                "Assim que o card for virado, compare a resposta e faça uma auto avaliação. \n"
                "Em seguida, escolha a opção que mais se adeque com o resultado da sua auto avaliação."
        ),
      ],
    ),
  );


  static Widget kartTitle = Container(
    child: Text("Kart",
      style: TextStyle(
          color: TemaApp.darkPrimary,
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
          child: Text("Instruções de uso",
            style: TextStyle(
                color: TemaApp.darkPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const Divider(),
        const Text(
            "Nesta atividade, você controlará um carro.\n"
                "Mova o carro para a direita ou para a esquerda a fim de coletar as partes da pergunta.\n"
                "Quando você coletar partes o suficiente, a pergunta completa aparecerá na tela, juntamente das possibilidades de resposta.\n"

        ),
      ],
    ),
  );


}