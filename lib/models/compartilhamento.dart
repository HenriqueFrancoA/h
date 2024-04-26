import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/publicacao.dart';

class Compartilhamento {
  String? id;
  late Publicacao publicacao;

  Compartilhamento({
    this.id,
    required this.publicacao,
  });

  static Future<Compartilhamento> fromSnapshot(
    DocumentSnapshot doc,
  ) async {
    DocumentSnapshot? publicacaoDoc;
    publicacaoDoc = await doc['PUBLICACAO'].get();

    return Compartilhamento(
      id: doc.id,
      publicacao: await Publicacao.fromSnapshot(publicacaoDoc!),
    );
  }

  Compartilhamento.fromJson(Map<String, dynamic> json) {
    publicacao = Publicacao.fromJson(json['PUBLICACAO']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICACAO'] = publicacao;
    return data;
  }
}
