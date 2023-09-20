import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';

class Decks extends StatefulWidget {
  const Decks({super.key});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> {

  List<Deck> _decks = [];


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

    setState(() {});

    print(_decks);
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
                    child: Text("${_decks[index].nome}"),
                  )
              );
            }
          )
      )

      ),
    );
  }
}
