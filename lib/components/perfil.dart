import 'package:flutter/material.dart';
import 'package:thoth/models/usuario.dart';

class Perfil extends StatelessWidget {
  final Usuario usuario;
  const Perfil({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Text(
          usuario.nome,
          style: const TextStyle(fontSize: 20),
        ));
  }
}
