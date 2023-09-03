import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/components/nossa_snackbar.dart';



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

  //TODO: USE A SNACKBAR; DONE!
  //TODO: WRAP CONTENTS IN A CONTAINER WITH MARGIN; DONE!
  //TODO: GET ANWSER AND INSERT IT IN A LIST; DONE!
  //TODO: CALL CREATE METHOD WITH QUESTION AND ANSWER; DONE!
  //TODO: MAKE ANSWERS TEXTFIELD AUTO-GENERATED
  //TODO: INSERT ANSWERS IN THE LIST. CALL CREATE
  //TODO: INSERT CONTENT IN A SCOLLABLE CONTAINER, LIKE LISTVIEW (OR CHANGE MARGIN SETTINGS)
  //TODO: DONE!

  void _cadastrarPergunta(context, pergunta, resposta) async {
    List<String> respostas = [];
    respostas.add(resposta);

    await Pergunta.create(pergunta, respostas, 0).then(
            (value) =>
                NossaSnackbar.mostrar(context, "Criada a pegunta ${pergunta} e a suas respostas: ${respostas[0]}")
    );
    //print("\nPegunta ${pergunta} e a sua resposta: ${resposta}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text ("Cadastar perguntas"),
      ),
        body: Container(
          margin: const EdgeInsets.only(
              top: 100.0, left: 42.0, right: 42.0, bottom: 35.0
          ),
          child: Column(
              children: [
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
                          context,
                          questionController.text,
                          answerController.text),
                      child: const Text("Cadastrar Pergunta",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0))),
                ),
              ]
          )
        )
    );
  }
}
