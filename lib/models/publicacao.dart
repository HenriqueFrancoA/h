import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/usuario.dart';

class Publicacao {
  String? id;
  late Usuario usuario;
  Publicacao? compartilhamento;
  String? texto;
  late bool imagem;
  late Timestamp dataCriacao;
  late int curtidas;
  late int comentarios;
  late int compartilhamentos;

  Publicacao({
    this.id,
    required this.usuario,
    this.compartilhamento,
    this.texto,
    required this.imagem,
    required this.dataCriacao,
    required this.curtidas,
    required this.comentarios,
    required this.compartilhamentos,
  });

  factory Publicacao.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Publicacao(
      id: snapshot.id,
      usuario: data['USUARIO'],
      compartilhamento: Publicacao.fromSnapshot(data['COMPARTILHAMENTO']),
      texto: data['TEXTO'],
      imagem: data['IMAGEM'],
      dataCriacao: data['DATA_CRIACAO'],
      curtidas: data['CURTIDAS'],
      comentarios: data['COMENTARIOS'],
      compartilhamentos: data['COMPARTILHAMENTOS'],
    );
  }

  Publicacao.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    usuario = json['USUARIO'];
    compartilhamento = Publicacao.fromJson(json['COMPARTILHAMENTO']);
    texto = json['TEXTO'];
    imagem = json['IMAGEM'];
    dataCriacao = json['DATA_CRIACAO'];
    curtidas = json['CURTIDAS'];
    comentarios = json['COMENTARIOS'];
    compartilhamentos = json['COMPARTILHAMENTOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['USUARIO'] = usuario;
    data['COMPARTILHAMENTO'] = compartilhamento;
    data['TEXTO'] = texto;
    data['IMAGEM'] = imagem;
    data['DATA_CRIACAO'] = dataCriacao;
    data['CURTIDAS'] = curtidas;
    data['COMENTARIOS'] = comentarios;
    data['COMPARTILHAMENTOS'] = compartilhamentos;
    return data;
  }
}
