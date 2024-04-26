import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:h/models/compartilhamento.dart';
import 'package:h/models/usuario.dart';

class Publicacao {
  String? id;
  late Usuario usuario;
  Compartilhamento? compartilhamento;
  String? texto;
  late bool imagem;
  late bool comentario;
  late Timestamp dataCriacao;
  late RxInt curtidas;
  late RxInt comentarios;
  late RxInt compartilhamentos;

  Publicacao({
    this.id,
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

  static Future<Publicacao> fromSnapshot(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    DocumentSnapshot usuarioDoc = await doc['USUARIO'].get();
    DocumentSnapshot? compartilhamentoDoc;

    if (doc['COMPARTILHAMENTO'] != null) {
      compartilhamentoDoc = await doc['COMPARTILHAMENTO'].get();
    }

    return Publicacao(
      id: doc.id,
      usuario: await Usuario.fromSnapshot(usuarioDoc),
      compartilhamento: compartilhamentoDoc != null
          ? await Compartilhamento.fromSnapshot(compartilhamentoDoc)
          : null,
      texto: data['TEXTO'],
      imagem: data['IMAGEM'],
      comentario: data['COMENTARIO'],
      dataCriacao: data['DATA_CRIACAO'],
      curtidas: RxInt(data['CURTIDAS']),
      comentarios: RxInt(data['COMENTARIOS']),
      compartilhamentos: RxInt(data['COMPARTILHAMENTOS']),
    );
  }

  Publicacao.fromJson(Map<String, dynamic> json) {
    usuario = Usuario.fromJson(json['USUARIO']);
    compartilhamento = Compartilhamento.fromJson(json['COMPARTILHAMENTO']);
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
    data['CURTIDAS'] = curtidas.value;
    data['COMENTARIOS'] = comentarios.value;
    data['COMPARTILHAMENTOS'] = compartilhamentos.value;
    return data;
  }
}
