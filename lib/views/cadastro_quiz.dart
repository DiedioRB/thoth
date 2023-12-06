import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/botao.dart';
import 'package:thoth/components/pesquisa.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/quiz.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/tema_app.dart';

class CadastroQuiz extends StatefulWidget {
  const CadastroQuiz({super.key});

  @override
  State<CadastroQuiz> createState() => CQuizzesState();
}

class CQuizzesState extends State<CadastroQuiz> with Pesquisa<Pergunta> {
  List<Quiz> cQuizzes = [];
  List<Pergunta> todasPerguntas = [];
  List<Pergunta> perguntas = [];

  List<DropdownMenuItem<Topico>> topicos = [];
  Topico? topico;

  Quiz novoQuiz = Quiz(nome: "", perguntasReferences: [], id: null);
  late FormBuilder formBuilder;

  @override
  void initState() {
    super.initState();

    formBuilder = FormBuilder(Quiz.getFields(quiz: novoQuiz));

    List<Quiz> quizzes = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Quiz.getCollection(db).get().then((value) => {
          if (value.docs.isNotEmpty)
            {
              for (var quiz in value.docs) {quizzes.add(quiz.data() as Quiz)},
              setState(() {
                cQuizzes = quizzes;
              })
            }
        });

    fetchTopicos();

    searchController.addListener(() {
      setState(() {
        search(todasPerguntas);
      });
    });
  }

  fetchTopicos() async {
    List<Topico> topicos = await Topico.todos();
    this.topicos.clear();
    for (var topico in topicos) {
      this.topicos.add(DropdownMenuItem(
            value: topico,
            key: Key(topico.id.toString()),
            child: Text(topico.descricao),
          ));
    }
    this.topicos.sort(
          (DropdownMenuItem<Topico> a, DropdownMenuItem<Topico> b) => a
              .value!.descricao
              .toLowerCase()
              .compareTo(b.value!.descricao.toLowerCase()),
        );
    if (mounted) {
      setState(() {
        topico = topicos[0];
      });
    }
  }

  void nQuiz(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Pergunta.getCollection(db).get().then((value) {
      todasPerguntas.clear();
      for (var pergunta in value.docs) {
        todasPerguntas.add(pergunta.data() as Pergunta);
        todasPerguntas.sort((a, b) =>
            a.pergunta.toLowerCase().compareTo(b.pergunta.toLowerCase()));
        if (mounted) {
          setState(() {
            search(todasPerguntas);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    nQuiz(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TemaApp.quizPrimary,
        title: const Text("Criar Quiz"),
      ),
      body: Center(
        child: Column(
          children: [
            formBuilder.build(),
            DropdownButton<Topico>(
                disabledHint: const Text("Selecione..."),
                items: topicos,
                onChanged: (Topico? topico) {
                  if (topico != null) {
                    setState(() {
                      this.topico = topico;
                    });
                  }
                },
                value: topico),
            barraPesquisa(),
            (itensPesquisa.isEmpty)
                ? const Text("Nenhum registro encontrado")
                : Expanded(
                    child: ListView.builder(
                        itemCount: itensPesquisa.length,
                        itemBuilder: (context, index) {
                          Pergunta p = itensPesquisa[index];
                          return CheckboxListTile(
                            title: Text(p.pergunta),
                            value: perguntas.any(
                              (element) => element.id == p.id,
                            ),
                            onChanged: (value) => {
                              setState(() {
                                if (value == false) {
                                  perguntas.removeWhere((element) {
                                    return element.id == p.id;
                                  });
                                } else {
                                  perguntas.add(p);
                                }
                              })
                            },
                          );
                        }),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Botao(
                    callback: () async {
                      List<DocumentReference> refs = [];
                      for (var pergunta in perguntas) {
                        refs.add(pergunta.id!);
                      }
                      Quiz novoQuiz = Quiz(
                          nome: formBuilder.values['nome'],
                          perguntasReferences: refs);
                      novoQuiz.create();
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                              content: Text("Quiz criado com sucesso!")));
                      Navigator.of(context).pop();
                    },
                    texto: "Salvar")
              ],
            )
          ],
        ),
      ),
    );
  }
}
