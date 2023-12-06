import 'package:thoth/models/pergunta.dart';

class PerguntaManager {
  int current = 0;
  int corretas = 0;
  int erradas = 0;

  List<Pergunta> perguntas = [
    Pergunta(
        pergunta: "Pergunta 1",
        respostas: ["Resposta 1", "Resposta 2", "Resposta 3"],
        respostaCorreta: 0),
    Pergunta(
        pergunta: "Pergunta 2",
        respostas: ["Resposta 4", "Resposta 5", "Resposta 6"],
        respostaCorreta: 0),
    Pergunta(
        pergunta: "Pergunta 3",
        respostas: ["Resposta 7", "Resposta 8", "Resposta 9"],
        respostaCorreta: 0),
    Pergunta(
        pergunta: "Pergunta 4",
        respostas: [
          "Resposta 10",
          "Resposta 11",
          "Resposta 12",
          "Resposta 13",
          "Resposta 14"
        ],
        respostaCorreta: 0),
    Pergunta(
        pergunta: "Pergunta 5", respostas: ["Sim", "Não"], respostaCorreta: 0),
  ];

  Pergunta get perguntaAtual {
    return perguntas[current];
  }

  bool answer(int answer) {
    if (perguntaAtual.respostaCorreta == answer) {
      corretas++;
      return true;
    } else {
      erradas++;
      return false;
    }
  }

  Pergunta? next() {
    if (current < perguntas.length - 1) {
      current++;
      return perguntas[current];
    }
    return null;
  }
}
