import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/hash_helper.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/models/interfaces/item_form_model.dart';

class Usuario implements ItemFormModel {
  static const String collection = "usuarios";

  final String nome;
  final String email;
  final List<String> salas;

  static List<ItemForm> getFields({Usuario? usuario}) {
    return [
      ItemForm.build(
          descricao: "nome",
          valor: usuario?.nome,
          icon: const Icon(Icons.person),
          modificadores: [ItemFormModifiers.naoNulo]),
      ItemForm.build(
          descricao: "email",
          valor: usuario?.email,
          icon: const Icon(Icons.email),
          modificadores: [ItemFormModifiers.naoNulo]),
      ItemForm.build(
          descricao: "senha",
          icon: const Icon(Icons.password),
          modificadores: [ItemFormModifiers.naoNulo, ItemFormModifiers.senha])
    ];
  }

  Usuario({
    required this.nome,
    required this.email,
    required this.salas,
  });

  static Future<Usuario?> login(String email, String senha) async {
    final FirebaseApp app = Firebase.app();
    final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
    Usuario? usuario;

    //Criptografia de senha
    senha = HashHelper.sha256Encrypt(senha);
    await getCollection(db)
        .where("email", isEqualTo: email)
        .where("senha", isEqualTo: senha)
        .get()
        .then((event) {
      usuario =
          (event.docs.isNotEmpty ? event.docs.first.data() : null) as Usuario?;
    });
    return usuario;
  }

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Usuario>(
        fromFirestore: Usuario.fromFirestore,
        toFirestore: (Usuario item, _) => item.toFirestore());
  }

  factory Usuario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Usuario(
        nome: data?['nome'],
        email: data?['email'],
        salas: (data?['salas'] is Iterable) ? List.from(data?['salas']) : []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nome": nome,
      "email": email,
      "salas": salas,
    };
  }

  @override
  String toString() {
    return nome;
  }
}
