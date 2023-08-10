import 'package:cloud_firestore/cloud_firestore.dart';

/// ESSA CLASSE SERVE APENAS PARA REFERÊNCIA PARA CRIAÇÃO DE OUTRAS CLASSES
/// ISSO FOI FEITO PORQUE MÉTODOS ESTÁTICOS NÃO SÃO IMPLEMENTADOS, PORTANTO
/// A CRIAÇÃO DOS MÉTODOS E FACTORIES FICA PARA OS FILHOS
class Model {
  static const String collection = "";

  final String nome;

  Model({required this.nome});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Model>(
        fromFirestore: Model.fromFirestore,
        toFirestore: (Model item, _) => item.toFirestore());
  }

  factory Model.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Model(nome: data?['nome']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nome": nome,
    };
  }
}
