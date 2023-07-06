class Pergunta {
  final String pergunta;
  final String resposta;
  Pergunta({required this.pergunta, required this.resposta});
  factory Pergunta.fromJson(Map<String, dynamic> json) =>
      _perguntaFromJson(json);

  Map<String, dynamic> toJson() => _perguntaToJson(this);

  @override
  String toString() => 'Pergunta<$pergunta>';
}

Pergunta _perguntaFromJson(Map<String, dynamic> json) {
  return Pergunta(
    pergunta: json['pergunta'],
    resposta: json['resposta'],
  );
}

// 2
Map<String, dynamic> _perguntaToJson(Pergunta instance) => <String, dynamic>{
      'pergunta': instance.pergunta,
      'resposta': instance.resposta,
    };
