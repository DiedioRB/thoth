import 'package:flutter/material.dart';

class PontuacaoQuiz extends StatelessWidget {

  //int? pontos = 0;

  PontuacaoQuiz({super.key});

  @override
  Widget build(BuildContext context) {
  final args = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pontuação"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Text(
                "Parabéns!",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Você fez:",
                style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              child: Text(
                "${args}",
                style: TextStyle(
                  fontSize: 55.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 50.0),
              child: Text(
                "Pontos!",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                    Navigator.of(context).pushNamed("/menu");
                  }
                ,
                child: Text("Menu Principal"))
          ],
        ),
      ),
    );
  }
}

