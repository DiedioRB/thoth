import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thoth/routes.dart';

class VerPerfil extends StatefulWidget {
  const VerPerfil({super.key});

  @override
  State<VerPerfil> createState() => _VerPerfil();
}

class _VerPerfil extends State<VerPerfil> {
  String getUserName() {
    return FirebaseAuth.instance.currentUser?.displayName ?? "";
  }

  String getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? "";
  }

  final String _foto =
      "https://cdn-icons-png.flaticon.com/512/4519/4519678.png";
  // TODO - Trocar conteúdo da string para um link direcionando para o Firebase Storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_foto),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            buildCampo('Nome', getUserName(),
                false), // TODO - Ajustar atualização dos dados em tela
            buildCampo('Email', getUserEmail(),
                false), // TODO - TODO - Ajustar atualização dos dados em tela
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.editarPerfil);
              },
              child: const Text("Editar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCampo(String label, String initialValue, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        initialValue: initialValue,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
      ),
    );
  }
}
