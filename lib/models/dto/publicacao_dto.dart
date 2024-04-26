import 'package:cloud_firestore/cloud_firestore.dart';

class PublicacaoDto {
  DocumentReference<Map<String, dynamic>>? usuario;
  DocumentReference<Map<String, dynamic>>? compartilhamento;
  String? texto;
  late bool imagem;
  late bool comentario;
  late Timestamp dataCriacao;
  late int curtidas;
  late int comentarios;
  late int compartilhamentos;

  PublicacaoDto({
    required this.usuario,
    this.compartilhamento,
    this.texto,
    required this.imagem,
    required this.comentario,
    required this.dataCriacao,
    required this.curtidas,
    required this.comentarios,
    required this.compartilhamentos,
  });

  PublicacaoDto.fromJson(Map<String, dynamic> json) {
    usuario = json['USUARIO'];
    compartilhamento = json['COMPARTILHAMENTO'];
    texto = json['TEXTO'];
    imagem = json['IMAGEM'];
    comentario = json['COMENTARIO'];
    dataCriacao = json['DATA_CRIACAO'];
    curtidas = json['CURTIDAS'];
    comentarios = json['COMENTARIOS'];
    compartilhamentos = json['COMPARTILHAMENTOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USUARIO'] = usuario;
    data['COMPARTILHAMENTO'] = compartilhamento;
    data['TEXTO'] = texto;
    data['IMAGEM'] = imagem;
    data['COMENTARIO'] = comentario;
    data['DATA_CRIACAO'] = dataCriacao;
    data['CURTIDAS'] = curtidas;
    data['COMENTARIOS'] = comentarios;
    data['COMPARTILHAMENTOS'] = compartilhamentos;
    return data;
  }
}
