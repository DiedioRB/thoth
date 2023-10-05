import 'package:flutter/material.dart';
import 'package:thoth/routes.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text("Thoth"),
        ),
        ListTile(
          title: const Text("Temas"),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.temas);
          },
        ),
        ListTile(
          title: const Text("Tópicos"),
          onTap: () {
            Navigator.of(context)
                .pushNamed(Routes.topicos, arguments: [null, true]);
          },
        ),
        ListTile(
          title: const Text("Quizzes"),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.quizzes);
          },
        ),
        ListTile(
          title: const Text("Flashcards"),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.flashcards);
          },
        ),
        ListTile(
          title: const Text("Cadastrar Perguntas"),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.cadastroPerguntas);
          },
        ),
        ListTile(
          title: const Text("Kart"),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.kart);
          },
        ),
        ListTile(
          title: const Text("Decks"),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.decks);
          },
        ),
      ],
    );
  }
}
