import 'package:flutter/material.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/tema_app.dart';

class ItemRanking extends StatelessWidget {
  final Map<String, dynamic> registro;
  final int posicao;

  const ItemRanking({super.key, required this.registro, required this.posicao});

  @override
  Widget build(BuildContext context) {
    Color? cor;
    switch (posicao) {
      case 0:
        cor = TemaApp.rankingFirst;
      case 1:
        cor = TemaApp.rankingSecond;
      case 2:
        cor = TemaApp.rankingThird;
    }
    String usuario = "";
    usuario = (registro["carregado"] as Usuario).nome;
    return ListTile(
      title: Text(
        usuario,
        style: TextStyle(color: cor),
      ),
      trailing: Text("${registro["pontuacao"].toString()} pontos"),
      leading: Text(posicao.toString()),
    );
  }
}
