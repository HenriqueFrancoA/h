import 'package:cloud_firestore/cloud_firestore.dart';

class CompartilhamentoDto {
  late DocumentReference<Map<String, dynamic>>? publicacao;

  CompartilhamentoDto({
    required this.publicacao,
  });

  CompartilhamentoDto.fromJson(Map<String, dynamic> json) {
    publicacao = json['PUBLICACAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICACAO'] = publicacao;
    return data;
  }
}
