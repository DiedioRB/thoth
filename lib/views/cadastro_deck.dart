import 'package:flutter/material.dart';

class CadastroDeck extends StatelessWidget {
  const CadastroDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Deck"),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField()
          ],
        ),
      )
    );
  }
}
