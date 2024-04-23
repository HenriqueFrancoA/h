import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/publicacao.dart';

class Comentario {
  String? id;
  late Publicacao publicacao;
  late Publicacao resposta;

  Comentario({
    this.id,
    required this.publicacao,
    required this.resposta,
  });

  factory Comentario.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Comentario(
      id: snapshot.id,
      publicacao: Publicacao.fromSnapshot(data['PUBLICACAO']),
      resposta: Publicacao.fromSnapshot(data['RESPOSTA']),
    );
  }

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    publicacao = Publicacao.fromJson(json['PUBLICACAO']);
    resposta = Publicacao.fromJson(json['RESPOSTA']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['RESPOSTA'] = resposta;
    data['SEGUINDO'] = publicacao;
    return data;
  }
}
