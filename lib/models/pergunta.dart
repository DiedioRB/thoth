import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pergunta {
  static const String collection = "perguntas";

  final DocumentReference? id;
  final String pergunta;
  final List<String> respostas;
  final int respostaCorreta;

  String get resposta {
    return respostas[respostaCorreta];
  }

  Pergunta(
      {required this.pergunta,
      required this.respostas,
      required this.respostaCorreta,
      this.id});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Pergunta>(
        fromFirestore: Pergunta.fromFirestore,
        toFirestore: (Pergunta item, _) => item.toFirestore());
  }

  factory Pergunta.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Pergunta(
        pergunta: data?['pergunta'],
        respostas: (data?['respostas'] is Iterable)
            ? List.from(data?['respostas'])
            : [],
        respostaCorreta: data?['correta'],
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "pergunta": pergunta,
      "respostas": respostas,
      "correta": respostaCorreta,
    };
  }

  @override
  String toString() {
    return pergunta;
  }

  static Future<Pergunta?> create(String perg, List<String> resp, int corretas) async {
    final FirebaseApp app = Firebase.app();
    final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
    final perguntaCollection = getCollection(db);

    final pergunta = Pergunta(pergunta: perg, respostas: resp, respostaCorreta: corretas);



    perguntaCollection.add(pergunta).then((documentSnapshot) => {
      print("adicionado!")
    });

  }

  static Future<Pergunta?> update(String perg, List<String> resp, int corretas) async {
    //MUST GET SNAPSHOT
    final FirebaseApp app = Firebase.app();
    final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
    final perguntaCollection = getCollection(db);

    final pergunta = Pergunta(pergunta: perg, respostas: resp, respostaCorreta: corretas);
    
    perguntaCollection.add(pergunta).then((documentSnapshot) => {
      print("Modificado!")
    });

  }


}
