import 'package:cloud_firestore/cloud_firestore.dart';

class CurtidaDto {
  late DocumentReference<Map<String, dynamic>>? usuario;
  late DocumentReference<Map<String, dynamic>>? publicacao;

  CurtidaDto({
    required this.usuario,
    required this.publicacao,
  });

  CurtidaDto.fromJson(Map<String, dynamic> json) {
    usuario = json['USUARIO'];
    publicacao = json['PUBLICACAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USUARIO'] = usuario;
    data['PUBLICACAO'] = publicacao;
    return data;
  }
}
