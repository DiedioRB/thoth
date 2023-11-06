//import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/ranking.dart';
import 'package:thoth/models/tema.dart';
import 'dart:math';

import 'package:thoth/models/topico.dart';
import 'package:thoth/models/usuario.dart';

//receber perguntas e randomizar array com elas
class Atividade {
  final int pontosPorAcerto = 10;

  //Perguntas que efetivamente aparecerão na atividade
  final List<Pergunta> _perguntas = [];
  //O index da pergunta mostrada na tela
  int _atual = 0;

  bool _finalizado = false;

  Tema tema;
  Topico? topico;
  List<Pergunta>? usarPerguntas;

  //A pontuação que vai ser enviada ao ranking
  int score = 0;

  int quantidadePerguntas = 10;

  int acertos = 0;
  int erros = 0;

  //Variável de controle pra verificar se a atividade foi carregada corretamente
  bool carregado = false;

  Function? onLoad;

  //TODO: colocar variáveis de repetição espaçada aqui

  Atividade(
      {required this.tema, this.topico, this.usarPerguntas, this.onLoad}) {
    if (usarPerguntas == null) {
      carregarPerguntas();
    } else {
      usarPerguntasEnviadas();
    }
  }

  //Essa função apenas chama outras funções para ser mais conveniente de usar
  void responder(int resposta) {
    marcarResposta(resposta);
    proximaPergunta();
  }

  Future<void> carregarPerguntas() async {
    //Todas as perguntas do tópico
    List<Pergunta> perguntasTopico = await topico!.perguntas;

    //A quantidade de perguntas que vão ter na atividade
    quantidadePerguntas = min(perguntasTopico.length, quantidadePerguntas);

    Random random = Random();
    List<int> registradas = [];

    _perguntas.clear();
    //Se a quantidade de perguntas totais for a quantidade de perguntas da atividade,
    //Coloca todas elas na atividade
    if (perguntasTopico.length <= quantidadePerguntas) {
      _perguntas.addAll(perguntasTopico.getRange(0, quantidadePerguntas));
    } else {
      //Adiciona perguntas aleatórias na atividade
      for (var i = 0; i < quantidadePerguntas; i++) {
        bool added = false;
        //Loop até achar uma pergunta não adicionada ainda
        while (!added) {
          int novo = random.nextInt(perguntasTopico.length - 1);
          if (!registradas.any((int num) => num == novo)) {
            _perguntas.add(perguntasTopico[novo]);
            registradas.add(novo);
            added = true;
          }
        }
      }
    }

    //No final, a variável _perguntas tem as perguntas pra mostrar na atividade
    carregado = true;
    onLoad?.call();
  }

  void usarPerguntasEnviadas() {
    _perguntas.addAll(usarPerguntas!);
    quantidadePerguntas = usarPerguntas!.length;
    carregado = true;
  }

  //Recebe o index da resposta selecionada e verifica se está correta
  //Se estiver correta, retorna [true], se não, retorna [false]
  bool marcarResposta(int resposta) {
    if (pergunta.respostaCorreta == resposta) {
      marcarAcerto();
      return true;
    }
    marcarErro();
    return false;
  }

  //Acertou a resposta
  void marcarAcerto() {
    acertos++;
    score += pontosPorAcerto;
    handleRepeticaoEspacada();
  }

  //Errou
  void marcarErro() {
    erros++;
    handleRepeticaoEspacada();
  }

  void proximaPergunta() {
    if (_perguntas.length == _atual + 1) {
      //Não tem mais perguntas pra mostrar, finaliza a atividade
      finalizar();
    } else {
      //Próxima pergunta
      _atual++;
    }
  }

  void finalizar() async {
    _finalizado = true;
    Ranking ranking = await Ranking.doTema(tema);
    Usuario? usuario = await Usuario.logged();
    if (usuario != null) {
      await ranking.adicionaRegistro(acertos, usuario);
    }
    // ranking.updateRegistros();
    //TODO: trabalhar o ranking aqui
  }

  void handleRepeticaoEspacada() {
    //TODO: aplicar a repetição espaçada aqui
    //Você tem acesso à pergunta atual aqui
    print("Repetição espaçada chamada");
  }

  //Retorna as perguntas da atividade
  List<Pergunta> get perguntas {
    return _perguntas;
  }

  //Retorna a pergunta atual
  Pergunta get pergunta {
    return _perguntas[_atual];
  }

  //Retorna se a atividade já acabou
  bool get finalizado {
    return _finalizado;
  }
}
