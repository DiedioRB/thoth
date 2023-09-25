import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/components/lista_cards.dart';

class AtividadeFlashcard extends StatefulWidget {
  final Deck deck;
  AtividadeFlashcard({super.key, required this.deck});

  @override
  State<AtividadeFlashcard> createState() => _AtividadeFlashcardState();
}

class _AtividadeFlashcardState extends State<AtividadeFlashcard> {
  Deck? _deck;
  List<Pergunta> _perguntas = [];

  @override
  void initState() {
    super.initState();
    _deck = widget.deck;

    _getPerguntas();
  }

  void _getPerguntas() async{
    _perguntas = await _deck!.perguntas;

    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards do deck ${_deck!.nome}")
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: ListaCards(perguntas: _perguntas,))
          ],
        ),
      )
    );
  }
}
