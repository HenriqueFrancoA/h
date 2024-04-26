import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Usuario extends Object {
  String? id;
  String? uId;
  late String email;
  late String usuario;
  String? telefone;
  late String senha;
  late Timestamp dataNascimento;
  late Timestamp dataCriacao;
  String? biografia;
  String? localizacao;
  late RxInt seguidores;
  late RxInt seguindo;
  late bool imagemUsuario;
  late int imagemUsuarioAtualizado;
  late bool imagemCapa;
  late int imagemCapaAtualizado;

  Usuario({
    this.id,
    this.uId,
    required this.email,
    required this.usuario,
    this.telefone,
    required this.senha,
    required this.dataNascimento,
    required this.dataCriacao,
    this.biografia,
    this.localizacao,
    required this.seguidores,
    required this.seguindo,
    required this.imagemUsuario,
    required this.imagemUsuarioAtualizado,
    required this.imagemCapa,
    required this.imagemCapaAtualizado,
  });

  static Future<Usuario> fromSnapshot(DocumentSnapshot snapshot) async {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Usuario(
      id: snapshot.id,
      uId: data['UID'],
      email: data['EMAIL'],
      usuario: data['USUARIO'],
      telefone: data['TELEFONE'],
      senha: data['SENHA'],
      dataNascimento: data['DATA_NASCIMENTO'],
      dataCriacao: data['DATA_CRIACAO'],
      biografia: data['BIOGRAFIA'],
      localizacao: data['LOCALIZACAO'],
      seguidores: RxInt(data['SEGUIDORES']),
      seguindo: RxInt(data['SEGUINDO']),
      imagemUsuario: data['IMAGEM_USUARIO'],
      imagemUsuarioAtualizado: data['IMAGEM_USUARIO_ATUALIZADO'],
      imagemCapa: data['IMAGEM_CAPA'],
      imagemCapaAtualizado: data['IMAGEM_CAPA_ATUALIZADO'],
    );
  }

  Usuario.fromJson(Map<String, dynamic> json) {
    uId = json['UID'];
    email = json['EMAIL'] ?? '';
    usuario = json['USUARIO'] ?? '';
    telefone = json['TELEFONE'];
    senha = json['SENHA'] ?? '';
    dataNascimento = json['DATA_NASCIMENTO'] ?? Timestamp.now();
    dataCriacao = json['DATA_CRIACAO'] ?? Timestamp.now();
    biografia = json['BIOGRAFIA'];
    localizacao = json['LOCALIZACAO'];
    seguidores = json['SEGUIDORES'] ?? 0;
    seguindo = json['SEGUINDO'] ?? 0;
    imagemUsuario = json['IMAGEM_USUARIO'] ?? false;
    imagemUsuarioAtualizado = json['IMAGEM_USUARIO_ATUALIZADO'] ?? 0;
    imagemCapa = json['IMAGEM_CAPA'] ?? false;
    imagemCapaAtualizado = json['IMAGEM_CAPA_ATUALIZADO'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UID'] = uId;
    data['EMAIL'] = email;
    data['USUARIO'] = usuario;
    data['TELEFONE'] = telefone;
    data['SENHA'] = senha;
    data['DATA_NASCIMENTO'] = dataNascimento;
    data['DATA_CRIACAO'] = dataCriacao;
    data['BIOGRAFIA'] = biografia;
    data['LOCALIZACAO'] = localizacao;
    data['SEGUIDORES'] = seguidores;
    data['SEGUINDO'] = seguindo;
    data['IMAGEM_USUARIO'] = imagemUsuario;
    data['IMAGEM_USUARIO_ATUALIZADO'] = imagemUsuarioAtualizado;
    data['IMAGEM_CAPA'] = imagemCapa;
    data['IMAGEM_CAPA_ATUALIZADO'] = imagemCapaAtualizado;
    return data;
  }
}
