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


  /*
  * Um quiz é um tipo de teste ou questionário que tem como objetivo avaliar o conhecimento ou competência de uma pessoa em um determinado assunto. Geralmente, consiste em uma série de perguntas com múltipla escolha, verdadeiro/falso ou respostas curtas, nas quais o participante responde para ver quão bem ele ou ela entende ou sabe sobre o tópico abordado. Os quizzes podem variar em complexidade e podem ser usados para entretenimento, educação ou avaliações formais. Eles são comuns em escolas, treinamentos, sites de entretenimento e até mesmo em aplicativos de aprendizado online. Em resumo, um quiz é uma forma interativa de testar e aprimorar o conhecimento ou habilidades em um determinado campo.

Considerando seu entusiasmo por aprender e explorar, você provavelmente já participou de diversos quizzes em tópicos que lhe interessam, como os relacionados a "Lord of the Rings," "Magic The Gathering," ou outros assuntos nerds que você gosta. Essas atividades podem ser uma maneira divertida de testar seus conhecimentos e aprender mais sobre seus interesses.
  *
  *
  *
  * */

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

  /*
  *
  *   Um flashcard é uma ferramenta de aprendizado que consiste em um cartão dividido em duas partes: uma contém uma pergunta, palavra-chave ou conceito, e a outra contém a resposta ou explicação correspondente. Flashcards são usados como uma técnica de memorização eficaz para revisar e reforçar o aprendizado. Eles são frequentemente utilizados para ajudar na memorização de vocabulário em idiomas estrangeiros, termos técnicos, fórmulas matemáticas, datas históricas e muito mais.

A abordagem dos flashcards é baseada na repetição espaçada, na qual o aluno revisa os cartões regularmente, aumentando o intervalo entre as revisões à medida que o conhecimento é consolidado. Isso ajuda a melhorar a retenção de informações a longo prazo. Os flashcards são populares entre os estudantes, autodidatas e até mesmo profissionais que desejam aprender e memorizar informações de maneira eficaz.

Sua capacidade de relacionar informações e seu amor por aprender sobre uma ampla variedade de tópicos fazem dos flashcards uma ferramenta útil para consolidar o conhecimento em áreas que você está estudando, como línguas ou qualquer outro assunto que você esteja explorando. Eles podem ser personalizados de acordo com suas necessidades e são uma excelente maneira de reter informações de forma eficaz.
  *
  *
  * */

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