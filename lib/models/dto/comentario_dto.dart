import 'package:cloud_firestore/cloud_firestore.dart';

class ComentarioDto {
  DocumentReference<Map<String, dynamic>>? publicacao;
  DocumentReference<Map<String, dynamic>>? resposta;

  ComentarioDto({
    required this.publicacao,
    required this.resposta,
  });

  ComentarioDto.fromJson(Map<String, dynamic> json) {
    publicacao = json['PUBLICACAO'];
    resposta = json['RESPOSTA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICACAO'] = publicacao;
    data['RESPOSTA'] = resposta;
    return data;
  }
}
