import 'package:flutter/material.dart';
import 'package:thoth/routes.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text("Thoth"),
        ),
        ListTile(
          title: Text("Perfil"),
          leading: Icon(Icons.people),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.perfil);
            },
        ),
        ListTile(
          title: Text("Temas"),
          leading: Icon(Icons.collections_bookmark),
        ),
        ListTile(
          title: Text("Rankings"),
          leading: Icon(Icons.trending_up),
        ),
        ListTile(
          title: Text("Salas de aula"),
          leading: Icon(Icons.school),
        )
      ],
    );
  }
}