import 'package:flutter/material.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/components/botao.dart';

class Pontuacao extends StatelessWidget {
  final int? pontos;

  const Pontuacao({super.key, this.pontos});

  @override
  Widget build(BuildContext context) {
    final args = pontos;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pontuação"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25.0),
              child: const Text(
                "Parabéns!",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
             const Text(
                "Você fez:",
                style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Text(
                "$args",
                style: const TextStyle(fontSize: 55.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 50.0),
              child: const Text(
                "Pontos!",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            Botao(
                texto: "Menu Principal",
                corFundo: TemaApp.darkPrimary,
                corTexto: TemaApp.branco,
                callback: () {
                  Navigator.of(context).pushNamed("/menu");
                }
            )
          ],
        ),
      ),
    );
  }
}
