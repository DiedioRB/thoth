import 'package:cloud_firestore/cloud_firestore.dart';

class Tema {
  static const String collection = "temas";

  final String descricao;

  Tema({required this.descricao});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Tema>(
        fromFirestore: Tema.fromFirestore,
        toFirestore: (Tema item, _) => item.toFirestore());
  }

  factory Tema.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Tema(descricao: data?['descricao']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "descricao": descricao,
    };
  }

  @override
  String toString() {
    return descricao;
  }
}
