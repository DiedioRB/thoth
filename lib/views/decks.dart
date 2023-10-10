import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/routes.dart';


class Decks extends StatefulWidget {
  const Decks({super.key});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> {

  final List<Deck> _decks = [];

  
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

  }





  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text ("Decks")
      ),
      body: Center(
        child: Container(
          //height: 350,
          margin: const EdgeInsets.only(top:25.0),
          child: ListView.builder(
            //shrinkWrap: true,
            itemCount: _decks.length,
            itemBuilder: (BuildContext context, int index) {
              return GridView.extent(
                shrinkWrap: true,
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  Card(
                    child: InkWell(
                      child:Center(
                        child: Text(_decks[index].nome),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.atividadeFlashcard, arguments: [null, _decks[index]]);
                      },
                    ),
                  )
                ],
              );
            }
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).pushNamed(Routes.cadastroDeck)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
