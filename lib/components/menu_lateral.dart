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
          child: Text("Dédalo"),
        ),
        ListTile(
          title: const Text("Perfil"),
          leading: const Icon(Icons.people),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.perfil);
          },
        ),
        ListTile(
          title: const Text("Temas"),
          // leading:  Icon(Icons.space_dashboard),
          leading: Icon(Icons.view_quilt),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.temas);
          },
        ),
        ListTile(
          title: const Text("Tópicos"),
          leading: const Icon(Icons.view_timeline),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.topicos, arguments: [null, true]);
          },
        ),
        ListTile(
          title: const Text("Quizzes"),
          leading: const Icon(Icons.quiz),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.quizzes);
          },
        ),
        ListTile(
          title: const Text("Flashcards"),
          leading: const Icon(Icons.collections_bookmark_outlined),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.flashcards);
          },
        ),
        ListTile(
          title: const Text("Cadastrar Perguntas"),
          leading: const Icon(Icons.library_add),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.cadastroPerguntas);
          },
        ),
        ListTile(
          title: const Text("Decks"),
          leading: const Icon(Icons.inventory_2),
          onTap: () {
            //Navigator.of(context).pushNamed(Routes.decks);
          },
        ),
      ],
    );
  }
}
