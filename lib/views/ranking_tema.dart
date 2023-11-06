import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_quiz.dart';
import 'package:thoth/components/item_ranking.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/models/ranking.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';

class RankingTema extends StatefulWidget {
  final Tema tema;

  const RankingTema({super.key, required this.tema});

  @override
  State<RankingTema> createState() => _RankingTemaState();
}

class _RankingTemaState extends State<RankingTema> {
  late Ranking ranking;
  bool _loaded = false;
  String dataInicio = "";
  String dataFim = "";

  List<Map<String, dynamic>> registros = [];

  @override
  void initState() {
    super.initState();

    _carregaRanking();
  }

  void _carregaRanking() async {
    ranking = await Ranking.doTema(widget.tema);
    await ranking.carregaUsuarios();
    registros = ranking.registros;
    registros.sort((a, b) => b["pontuacao"] - a["pontuacao"]);

    dataInicio = date(ranking.semana!);
    dataFim = date(ranking.semana!.add(const Duration(days: 6)));
    setState(() {
      _loaded = true;
    });
  }

  String date(DateTime date) => "${date.day}/${date.month}/${date.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TemaApp.quizPrimary,
        title: Text("Ranking de ${widget.tema.descricao}"),
      ),
      body: Center(
          child: _loaded
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("De $dataInicio a $dataFim",
                          style: TextStyle(fontSize: TemaApp.titleSize)),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: registros.length,
                          itemBuilder: (context, index) {
                            return ItemRanking(
                              registro: registros[index],
                              posicao: index,
                            );
                          }),
                    ),
                  ],
                )
              : const CircularProgressIndicator()),
    );
  }
}
