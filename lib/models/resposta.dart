import 'package:cloud_firestore/cloud_firestore.dart';

class Resposta {
  final int dificuldade;
  final DocumentReference pergunta;
  final DocumentReference tema;

  Resposta({
    required this.dificuldade,
    required this.pergunta,
    required this.tema
  });

factory Resposta.fromSnapshot(DocumentSnapshot snapshot) {
  Map data = snapshot.data() as Map;
  return Resposta(
    dificuldade: data['dificuldade'],
    pergunta: data['pergunta'],
    tema: data['tema'],
  );
}

}