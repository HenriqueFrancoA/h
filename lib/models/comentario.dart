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

  static Future<Comentario> fromSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot publicacaoDoc = await doc['PUBLICACAO'].get();
    DocumentSnapshot respostaDoc = await doc['RESPOSTA'].get();

    return Comentario(
      id: doc.id,
      publicacao: await Publicacao.fromSnapshot(publicacaoDoc),
      resposta: await Publicacao.fromSnapshot(respostaDoc),
    );
  }

  Comentario.fromJson(Map<String, dynamic> json) {
    publicacao = Publicacao.fromJson(json['PUBLICACAO']);
    resposta = Publicacao.fromJson(json['RESPOSTA']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICACAO'] = publicacao;
    data['RESPOSTA'] = resposta;
    return data;
  }
}
