import 'package:cloud_firestore/cloud_firestore.dart';

class Topico {
  static const String collection = "topicos";

  final String nome;

  Topico({required this.nome});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Topico>(
        fromFirestore: Topico.fromFirestore,
        toFirestore: (Topico item, _) => item.toFirestore());
  }

  factory Topico.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Topico(nome: data?['nome']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nome": nome,
    };
  }
}
