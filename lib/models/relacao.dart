import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/usuario.dart';

class Relacao {
  String? id;
  late Usuario usuario;
  late Usuario seguindo;

  Relacao({
    this.id,
    required this.usuario,
    required this.seguindo,
  });

  static Future<Relacao> fromSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot usuarioDoc = await doc['USUARIO'].get();
    DocumentSnapshot seguindoDoc = await doc['SEGUINDO'].get();

    return Relacao(
      id: doc.id,
      usuario: await Usuario.fromSnapshot(usuarioDoc),
      seguindo: await Usuario.fromSnapshot(seguindoDoc),
    );
  }

  Relacao.fromJson(Map<String, dynamic> json) {
    usuario = Usuario.fromJson(json['USUARIO']);
    seguindo = Usuario.fromJson(json['SEGUINDO']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USUARIO'] = usuario;
    data['SEGUINDO'] = seguindo;
    return data;
  }
}
