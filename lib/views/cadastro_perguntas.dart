import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thoth/helpers/openai_helper.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/tema_app.dart';
import 'package:thoth/components/botao.dart';

class CadastroPerguntas extends StatefulWidget {
  final Tema tema;
  CadastroPerguntas({super.key, required this.tema});

  @override
  State<CadastroPerguntas> createState() => _CadastroPerguntasState();
}

class _CadastroPerguntasState extends State<CadastroPerguntas> {
  List<Pergunta> perguntas = [];
  List<Pergunta> perguntasSelecionadas = [];

  bool fetching = false;

  final int minQuestions = 2, maxQuestions = 15, defaultQuestions = 5;

  final _formKey = GlobalKey<FormState>();
  final assuntoController = TextEditingController();
  final quantidadeController = TextEditingController(text: "5");

  void _gerarPerguntas(String assunto, int quantidade) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        fetching = true;
      });
      List<Pergunta> perguntas = [];
      try {
        perguntas = await OpenAIHelper.gerarQuestoes(
            assunto: assunto, quantidade: quantidade, tema: widget.tema);
      } catch (exception) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text(
                "Um erro ocorreu ao gerar as questões, tente novamente mais tarde")));
      } finally {
        setState(() {
          fetching = false;
        });
      }

      setState(() {
        this.perguntas.addAll(perguntas);
      });
    }
  }

  void _salvarPerguntas() async {
    if (perguntasSelecionadas.isNotEmpty) {
      for (Pergunta pergunta in perguntasSelecionadas) {
        await pergunta.create();
      }
      perguntasSelecionadas.clear();
      setState(() {
        perguntas.clear();
      });
      _mostrarAvisoPerguntasSalvas();
    } else {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text("Nenhuma questão selecionada!")));
    }
  }

  void _mostrarAvisoPerguntasSalvas() {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text("Perguntas salvas com sucesso!")));
  }

  void _abrirPergunta(Pergunta pergunta) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(pergunta.pergunta),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: pergunta.respostas.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        pergunta.respostas[index],
                      ),
                      leading: (index == pergunta.respostaCorreta)
                          ? Icon(
                              Icons.check,
                              color: TemaApp.success,
                            )
                          : null,
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Fechar"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastar perguntas no tema ${widget.tema.descricao}"),
      ),
      body: Container(
        margin: const EdgeInsets.only(
            top: 50.0, left: 42.0, right: 42.0, bottom: 35.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: assuntoController,
                decoration: const InputDecoration(labelText: "Assunto"),
              ),
              TextFormField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value != null) {
                    int quantidade = int.parse(value);
                    return (quantidade < minQuestions ||
                            quantidade > maxQuestions)
                        ? "A quantidade deve estar entre $minQuestions e $maxQuestions"
                        : null;
                  }
                  return "Insira um valor entre $minQuestions e $maxQuestions";
                },
                decoration: const InputDecoration(labelText: "Quantidade"),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 80),
                child: Botao(
                    texto: "Gerar questões",
                    corFundo: TemaApp.darkPrimary,
                    corTexto: TemaApp.branco,
                    callback: () {
                      int quantidade = int.parse(quantidadeController.text);
                      _gerarPerguntas(assuntoController.text, quantidade);
                    }
                )
              ),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 25),
                  child: Botao(
                      texto: "Salvar Selecionadas",
                      corFundo: TemaApp.darkPrimary,
                      corTexto: TemaApp.branco,
                      callback: () {
                        _salvarPerguntas();
                      }
                  )
              ),

              fetching
                  ? const Column(
                      children: [
                        CircularProgressIndicator(),
                        Text("Gerando perguntas, aguarde!"),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: perguntas.length,
                          itemBuilder: (context, index) {
                            Pergunta p = perguntas[index];
                            return CheckboxListTile(
                              secondary: InkWell(
                                onTap: () {
                                  _abrirPergunta(perguntas[index]);
                                },
                                child: Icon(Icons.remove_red_eye),
                              ),
                              title: Text(p.pergunta),
                              value: perguntasSelecionadas.any(
                                (element) => element.pergunta == p.pergunta,
                              ),
                              onChanged: (value) => {
                                setState(() {
                                  if (value == false) {
                                    perguntasSelecionadas
                                        .removeWhere((element) {
                                      return element.pergunta == p.pergunta;
                                    });
                                  } else {
                                    perguntasSelecionadas.add(p);
                                  }
                                })
                              },
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
