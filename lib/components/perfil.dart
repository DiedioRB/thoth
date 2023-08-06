import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/usuario.dart';

class Perfil extends StatelessWidget {
  final Usuario usuario;
  const Perfil({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Text(usuario.nome);
  }
}
