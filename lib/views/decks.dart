import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/pesquisa.dart';
import 'package:thoth/models/deck.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';

class Decks extends StatefulWidget {
  final Tema? tema;
  final Topico? topico;
  const Decks({super.key, this.tema, this.topico});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> with Pesquisa<Deck> {
  final List<Deck> _decks = [];

  @override
  void initState() {
    super.initState();

    _getDecks();
    searchController.addListener(() {
      setState(() {
        search(_decks);
      });
    });
  }

  void _getDecks() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (widget.topico != null) {
      await Deck.getCollection(db)
          .where("topico", isEqualTo: widget.topico!.id)
          .get()
          .then((value) {
        _decks.clear();
        for (var deck in value.docs) {
          _decks.add(deck.data() as Deck);
        }

        setState(() {
          search(_decks);
        });
      });
    } else {
      await Deck.getCollection(db).get().then((value) {
        _decks.clear();
        for (var deck in value.docs) {
          _decks.add(deck.data() as Deck);
        }

        setState(() {
          search(_decks);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("Decks")),
      body: Center(
          child: Container(
              //height: 350,
              margin: const EdgeInsets.only(top: 25.0),
              child: Column(
                children: [
                  barraPesquisa(),
                  Expanded(
                    child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                        //shrinkWrap: true,
                        itemCount: itensPesquisa.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 2,
                            child: InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 18),
                                child: Text(itensPesquisa[index].nome),
                              ),
                              onTap: () {
                                if (widget.tema != null) {
                                  Navigator.of(context).pushNamed(
                                      Routes.atividadeFlashcard,
                                      arguments: [
                                        widget.tema,
                                        widget.topico,
                                        itensPesquisa[index]
                                      ]);
                                } else {
                                  Navigator.of(context).pushNamed(
                                      Routes.flashcards,
                                      arguments: [null, itensPesquisa[index]]);
                                }
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.of(context).pushNamed(Routes.cadastroDeck)},
        tooltip: "Novo deck",
        child: const Icon(Icons.add),
      ),
    );
  }
}
