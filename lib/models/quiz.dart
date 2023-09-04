import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/models/pergunta.dart';

/// ESSA CLASSE SERVE APENAS PARA REFERÊNCIA PARA CRIAÇÃO DE OUTRAS CLASSES
/// ISSO FOI FEITO PORQUE MÉTODOS ESTÁTICOS NÃO SÃO IMPLEMENTADOS, PORTANTO
/// A CRIAÇÃO DOS MÉTODOS E FACTORIES FICA PARA OS FILHOS
class Quiz {
  static const String collection = "quizzes";

  final DocumentReference? id;
  final String nome;
  final List<DocumentReference> perguntasReferences;
  final List<Pergunta> _perguntas = [];

  static List<ItemForm> getFields({Quiz? quiz}) {
    return [
      ItemForm.build(
          descricao: "nome",
          valor: quiz?.nome,
          icon: const Icon(Icons.edit),
          modificadores: [ItemFormModifiers.naoNulo]),
    ];
  }

  Quiz({required this.nome, required this.
  perguntasReferences, this.id});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Quiz>(
        fromFirestore: Quiz.fromFirestore,
        toFirestore: (Quiz item, _) => item.toFirestore());
  }

  factory Quiz.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<DocumentReference> perguntas = [];
    for (var pergunta in data?['perguntas']) {
      perguntas.add(pergunta);
    }
    return Quiz(
        nome: data?['nome'],
        perguntasReferences: perguntas,
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {"nome": nome, "perguntas": perguntasReferences};
  }

  Future<List<Pergunta>> get perguntas async {
    if (_perguntas.isEmpty) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Pergunta.getCollection(db)
          .where(FieldPath.documentId, whereIn: perguntasReferences)
          .get()
          .then((value) => {
                _perguntas.clear(),
                for (var pergunta in value.docs)
                  {_perguntas.add(pergunta.data() as Pergunta)}
              });
    }
    return _perguntas;
  }

  atualizaReferencias(List<Pergunta> perguntas) {
    perguntasReferences.clear();
    for (var pergunta in perguntas) {
      perguntasReferences.add(pergunta.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Quiz.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Quiz.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Quiz.getCollection(db).doc(id?.id).delete();
  }
}
