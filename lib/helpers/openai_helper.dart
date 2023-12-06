import 'dart:convert';

import 'package:thoth/models/pergunta.dart';
import 'package:http/http.dart' as http;
import 'package:thoth/models/tema.dart';
import 'package:thoth/options.dart';

class OpenAIHelper {
  static const String _secret = Options.OPENAI_KEY;

  static Future<List<Pergunta>> gerarQuestoes(
      {required String assunto,
      required int quantidade,
      required Tema tema}) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $_secret"
    };

    Uri url = Uri.https("api.openai.com", "v1/chat/completions");

    Object body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              'Você é um gerador de questões de quiz. Você deve receber um termo ou frase e gerar $quantidade questões relacionadas ao assunto, dispondo também de 2 a 5 alternativas de respostas, sendo apenas uma verdadeira. O retorno deve ser no formato JSON, no formato [{"questao":"...","alternativas":[...], "correta":"..."},...], sendo que o campo "correta" possui um número indicando a posição da resposta correta dentro da array de alternativas iniciando em 0'
        },
        {"role": "user", "content": assunto}
      ],
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    var json = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var perguntasRecebidas = json["choices"][0]["message"]["content"];

    var perguntasJson = jsonDecode(perguntasRecebidas);

    List<Pergunta> perguntas = [];
    for (var pergunta in perguntasJson) {
      List<String> respostas = [];
      for (var alternativa in pergunta["alternativas"]) {
        respostas.add(alternativa);
      }

      int correta = 0;
      correta = int.parse(pergunta["correta"].toString());

      perguntas.add(Pergunta(
          pergunta: pergunta["questao"],
          respostas: respostas,
          respostaCorreta: correta,
          temaReference: tema.id));
    }

    return perguntas;
  }
}
