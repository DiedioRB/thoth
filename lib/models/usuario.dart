import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/models/interfaces/item_form_model.dart';

class Usuario implements ItemFormModel {
  static const String collection = "usuarios";

  final DocumentReference? id;
  final String nome;
  final String email;
  final List<String> salas;

  static List<ItemForm> getFieldsCadastro({Usuario? usuario}) {
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

  static List<ItemForm> getFieldsLogin({Usuario? usuario}) {
    return [
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
    this.id,
  });

  static Future<Usuario?> login(String email, String senha) async {
    try {
      User? user = await AuthHelper.signIn(email: email, senha: senha);
      if (user != null) {
        //Fazer login
        Usuario? usuario = await logged();
        return usuario;
      }
    } on FirebaseAuthException catch (_) {
      return null;
    }
    return null;
  }

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Usuario>(
        fromFirestore: Usuario.fromFirestore,
        toFirestore: (Usuario item, _) => item.toFirestore());
  }

  static Future<Usuario?> logged() async {
    final FirebaseApp app = Firebase.app();
    final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
    Usuario? usuario;
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await (getCollection(db)
          .where("email", isEqualTo: user.email)
          .get()
          .then((value) {
        usuario = (value.docs.isNotEmpty ? value.docs.first.data() : null)
            as Usuario?;
      }));
    }
    return usuario;
  }

  factory Usuario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Usuario(
        nome: data?['nome'],
        email: data?['email'],
        salas: (data?['salas'] is Iterable) ? List.from(data?['salas']) : [],
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nome": nome,
      "email": email,
      "salas": salas,
    };
  }

  create({required String uid}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Usuario.getCollection(db).doc(uid).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Usuario.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Usuario.getCollection(db).doc(id?.id).delete();
  }

  @override
  String toString() {
    return nome;
  }
}
