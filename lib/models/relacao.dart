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

  factory Relacao.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Relacao(
      id: snapshot.id,
      usuario: Usuario.fromSnapshot(data['USUARIO']),
      seguindo: Usuario.fromSnapshot(data['SEGUINDO']),
    );
  }

  Relacao.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    usuario = Usuario.fromJson(json['USUARIO']);
    seguindo = Usuario.fromJson(json['SEGUINDO']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['USUARIO'] = usuario;
    data['SEGUINDO'] = seguindo;
    return data;
  }
}
