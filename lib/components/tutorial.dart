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
            "O quiz é um tipo de teste que tem como objetivo avaliar o conhecimento de uma pessoa sobre um determinado assunto. \n"
                "Ele consiste de uma série de perguntas com múltipla escolha, "
                "nas quais o participante responde para ver quão bem ele ou ela entende sobre o tópico abordado.",
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
          "Para realizar a atividade, selecione um dos quizzes na próxima tela.\n"
              "Em seguida, você verá uma pergunta e algumas opções de resposta."
              "Selecione a resposta que você julgar correta e toque em \"próximo\". \n"
              "Ao fim da atividade, uma tela com a sua pontuação será apresentada",
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
            "O flashcard é uma atividade de aprendizado que consiste em um cartão dividido em duas partes: "
                "uma contém uma pergunta, palavra-chave ou conceito, e a outra contém a resposta ou explicação correspondente. "
                "Flashcards são usados como uma técnica de memorização para revisar e reforçar o aprendizado.",
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
            "Você verá um cartão com uma pergunta. Responda à pergunta mentalmente e toque no cartão para revelar a resposta. "
                "Em seguida, escolha uma das opções que melhor descrevem a sua dificuldade em lembrar da resposta. \n"
                "Esse é um exercício autoavaliativo, logo a falta de honestidade com suas respostas acarretará em prejuízo somente para seu aprendizado.",
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
            "O kart é uma maneira inovadora de gamificar o aprendizado. "
                "Nele o participante controlará um carro e ao coletar as moedas, "
                "uma pergunta, justo de suas respostas, será apresentada na tela. \n"
                "Dessa forma, a atividade o Kart visa amenizar a dificuldade de aprendizado e torná-la mais instigante.",
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
            "Você controlará um carro. Toque na direção que deseja mover o carro e colete as moedas que aparecerem na pista. \n"
                "A cada moeda coletada, uma nova parte da pergunta aparecerá no topo da tela. "
                "Coletadas todas as moedas. Serão apresentadas as respostas para aquela pergunta. Selecione a resposta que julgar correta "
                "e continue o jogo. Ao fim da atividade, será apresentada a sua pontuação",
            style: TextStyle(
              color: TemaApp.kartSecondary,
            )
        )
      ],
    ),
  );


}