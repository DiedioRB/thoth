//import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'dart:math';

//receber perguntas e randomizar array com elas
class Atividade {
  final List<Pergunta> _perguntas = [];


  List<Pergunta> randomizePerguntas(List<Pergunta> perguntas, int? quantidade) {
    List<Pergunta> perguntasAleatorias = [];
    Random aleatorio = Random();
    int qtd = quantidade ?? 5; //caso quantidade não seja especificado
    if(qtd < perguntas.length) {
      while(perguntasAleatorias.length < qtd) {
        int indiceAleatorio = aleatorio.nextInt(perguntas.length);
        Pergunta perguntaSelecionada = perguntas[indiceAleatorio];
        if(!_perguntas.contains(perguntaSelecionada)) {
          perguntasAleatorias.add(perguntaSelecionada);
        }
      }
    } else {
      perguntasAleatorias = perguntas;
    }

    return perguntasAleatorias;
  }

}