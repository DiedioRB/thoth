import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/pergunta.dart';

class Perguntas extends StatefulWidget {
  const Perguntas({super.key});

  //TODO: LOOK FOWARD TO UNDERSTAND HOW A STATEFUL WIDGET WORKS ON FLUTTER
  @override
  State<Perguntas> createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {
  List<Pergunta> _perguntas = [];

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            child: Text(
                "Tela"
            )
        )
    );
  }
}



