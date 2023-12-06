import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfil();
}

class _EditarPerfil extends State<EditarPerfil> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String getUserID() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  String getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? "";
  }

  String getUserName() {
    return FirebaseAuth.instance.currentUser?.displayName ?? "";
  }

  void _updatePerfil() async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('usuarios').doc(getUserID());
    await userRef.update({
      'nome': _nomeController.text,
      'email': _emailController.text,
    });
  }

  final String _foto =
      "https://cdn-icons-png.flaticon.com/512/4519/4519678.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _nomeController,
                enabled: true,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _emailController,
                enabled: true,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: getUserEmail());
              },
              child: const Text("Reset de Senha"),
            ),
            TextButton(
              onPressed: () {
                _updatePerfil(); // TODO - Validar a atualização dos dados em tela
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Perfil atualizado com sucesso!')),
                );
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
