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

  factory Curtida.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Curtida(
      id: snapshot.id,
      usuario: Usuario.fromSnapshot(data['USUARIO']),
      publicacao: Publicacao.fromSnapshot(data['PUBLICACAO']),
    );
  }

  Curtida.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    usuario = Usuario.fromJson(json['USUARIO']);
    publicacao = Publicacao.fromJson(json['PUBLICACAO']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['USUARIO'] = usuario;
    data['SEGUINDO'] = publicacao;
    return data;
  }
}
