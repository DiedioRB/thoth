import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/models/pergunta.dart';

class Decks extends StatefulWidget {
  const Decks({super.key});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> {

  List<Deck> _decks = [];

  List<Pergunta> _decksPerguntas = [];


  @override
  void initState() {
    super.initState();

    _getDecks();

  }

  void _getDecks() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Deck.getCollection(db).get().then((value) => {
      _decks.clear(),
      for(var deck in value.docs) {
        _decks.add(deck.data() as Deck)
      }
    });

    _getPerguntas(_decks);

    setState(() {});

    print(_decks);

  }

  void _getPerguntas(List<Deck> decks) async {
    Deck umDeck = decks[0];
    _decksPerguntas = await umDeck.perguntas;

    setState(() {});
    print(_decksPerguntas);

  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text ("Decks")
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top:25.0),
          child: ListView.builder(
            itemCount: _decks.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                  child: Card(
                    child: InkWell(
                      child: Text("${_decks[index].nome}"),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.atividadeFlashcard, arguments: _decks[index]);
                      },
                    )
                  )
              );
            }
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).pushNamed(Routes.cadastroDeck)
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
