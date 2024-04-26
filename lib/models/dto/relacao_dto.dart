import 'package:cloud_firestore/cloud_firestore.dart';

class RelacaoDto {
  DocumentReference<Map<String, dynamic>>? usuario;
  DocumentReference<Map<String, dynamic>>? seguindo;

  RelacaoDto({
    required this.usuario,
    required this.seguindo,
  });

  RelacaoDto.fromJson(Map<String, dynamic> json) {
    usuario = json['USUARIO'];
    seguindo = json['SEGUINDO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USUARIO'] = usuario;
    data['SEGUINDO'] = seguindo;
    return data;
  }
}
