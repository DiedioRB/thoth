import 'package:flutter/material.dart';
import 'package:thoth/models/deck.dart';

class Decks extends StatefulWidget {
  const Decks({super.key});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> {



  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text ("Decks")
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top:25.0),
          child: Column(
            children: [
              Card(
                  child: InkWell(
                    child: Center(
                      child: Text(
                          "E aí",
                          style: Theme.of(context).textTheme.titleLarge
                      ),
                    )
                  )
              )
            ],
          )
      )

      ),
    );
  }
}
