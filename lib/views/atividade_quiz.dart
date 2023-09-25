import 'package:flutter/material.dart';
import 'package:thoth/components/atividades.dart';
import 'package:thoth/models/pergunta.dart';

class AtividadeQuiz extends StatefulWidget {
  const AtividadeQuiz({super.key, required this.listaPerguntas});

  final List<Pergunta> listaPerguntas;

  @override
  State<AtividadeQuiz> createState() => _AtividadeQuizState();
}

class _AtividadeQuizState extends State<AtividadeQuiz> {

  List<Pergunta> perguntas = [];

  @override
  void initState() {
    super.initState();
    perguntas = widget.listaPerguntas;
  }

  @override
  Widget build(BuildContext context) {
    return Atividade(perguntas: perguntas);
  }
}