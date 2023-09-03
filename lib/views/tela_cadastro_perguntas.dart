import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';



class CadastroPerguntas extends StatelessWidget {
  CadastroPerguntas({super.key});

  final questionController = TextEditingController();
  final answerController = TextEditingController();

  void _teste() async {
    //final FirebaseApp app = Firebase.app();
    //final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
    List<String> teste = ["um", "dois", "três"];
    await Pergunta.create("teste", teste, 8);
    //var perg;
    //Pergunta.getCollection(db)
    //    .get()
    //    .then((value) {
    //      perg = value.docs.first.data();
    //      print("\n\n t== ${perg}");
    //});

    //print("\n\n TESTE: ${perg}");

  }

  void _cadastrarPergunta(pergunta, resposta) {
    print("\nPegunta ${pergunta} e a sua resposta: ${resposta}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text ("Cadastar perguntas"),
      ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 35.0
              ),
            ),
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
                  onPressed: () => _cadastrarPergunta(
                      questionController.text,
                      answerController.text),
                  child: const Text("Cadastrar Pergunta",
                      style: TextStyle(
                          color: Colors.blueAccent, fontSize: 20.0))),
            ),
          ]
        )
    );
  }
}
