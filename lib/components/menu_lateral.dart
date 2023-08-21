import 'package:flutter/material.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary),
            child: const Text("Thoth")),
        const ListTile(
          title: Text("Temas"),
          leading: Icon(Icons.collections_bookmark),
        ),
        const ListTile(
          title: Text("Rankings"),
          leading: Icon(Icons.trending_up),
        ),
        const ListTile(
          title: Text("Salas de aula"),
          leading: Icon(Icons.school),
        )
      ],
    );
  }
}
