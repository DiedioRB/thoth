import 'package:flutter/material.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/routes.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  void _logout(BuildContext context) {
    AuthHelper.logout();
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              tooltip: "Desconectar",
            )
          ]),
      body: Center(
        child: TextButton(
            onPressed: () => _logout(context), child: const Text("logout")),
      ),
    ));
  }
}
