import 'package:flutter/material.dart';
import 'package:thoth/components/atividades.dart';

class AtividadeQuiz extends StatefulWidget {
  const AtividadeQuiz({super.key});

  @override
  State<AtividadeQuiz> createState() => _AtividadeQuizState();
}

class _AtividadeQuizState extends State<AtividadeQuiz> {

  @override
  Widget build(BuildContext context) {
    return Atividade();
  }
}