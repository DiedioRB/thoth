import 'package:flutter/material.dart';


class CadastroPerguntas extends StatelessWidget {
  CadastroPerguntas({super.key});

  final questionController = TextEditingController();
  final answerController = TextEditingController();


  void _cadastrarPergunta(context, pergunta, resposta) async {
    List<String> respostas = [];
    respostas.add(resposta);

    //await Pergunta.create(pergunta, respostas, 0).then(
    //        (value) =>
    //            NossaSnackbar.mostrar(context, "Criada a pegunta ${pergunta} e a suas respostas: ${respostas[0]}")
    //);
    //print("\nPegunta ${pergunta} e a sua resposta: ${resposta}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastar perguntas"),
        ),
        body: Container(
            margin: const EdgeInsets.only(
                top: 100.0, left: 42.0, right: 42.0, bottom: 35.0),
            child: Column(children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: "Pergunta"),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: "Resposta"),
              ),
              Container(
                margin: const EdgeInsets.only(top: 100.0),
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[50]),
                child: TextButton(
                    onPressed: () => _cadastrarPergunta(context,
                        questionController.text, answerController.text),
                    child: const Text("Cadastrar Pergunta",
                        style: TextStyle(
                            color: Colors.blueAccent, fontSize: 20.0))),
              ),
            ])));
  }
}
