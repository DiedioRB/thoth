import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/tema_app.dart';

class ListaCards extends StatelessWidget {
  final List<Pergunta> perguntas;
  const ListaCards({super.key, required this.perguntas});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(perguntas.length, (index) {
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: FlipCard(
                  fill: Fill.fillBack,
                  direction: FlipDirection.HORIZONTAL,
                  side: CardSide.FRONT,
                  front: Container(
                    decoration: BoxDecoration(
                        color: TemaApp.darkSecondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(perguntas[index].pergunta,
                          style: const TextStyle(color: Colors.white)),
                    )),
                  ),
                  back: Container(
                    decoration: BoxDecoration(
                        color: TemaApp.lightPrimary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(perguntas[index].resposta,
                          style: const TextStyle(color: Colors.white)),
                    )),
                  ),
                )));
      }),
    );
  }
}
