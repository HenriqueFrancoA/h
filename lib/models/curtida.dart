import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/models/usuario.dart';

class Curtida {
  String? id;
  late Usuario usuario;
  late Publicacao publicacao;

  Curtida({
    this.id,
    required this.usuario,
    required this.publicacao,
  });

  static Future<Curtida> fromSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot usuarioDoc = await doc['USUARIO'].get();
    DocumentSnapshot publicacaoDoc = await doc['PUBLICACAO'].get();

    return Curtida(
      id: doc.id,
      usuario: await Usuario.fromSnapshot(usuarioDoc),
      publicacao: await Publicacao.fromSnapshot(publicacaoDoc),
    );
  }

  Curtida.fromJson(Map<String, dynamic> json) {
    usuario = Usuario.fromJson(json['USUARIO']);
    publicacao = Publicacao.fromJson(json['PUBLICACAO']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USUARIO'] = usuario;
    data['SEGUINDO'] = publicacao;
    return data;
  }
}
