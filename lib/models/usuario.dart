import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  static const String collection = "usuarios";

  final String nome;
  final String email;
  final List<String> salas;

  Usuario({required this.nome, required this.email, required this.salas});

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
