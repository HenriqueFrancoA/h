import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/usuario.dart';

class UsuarioApi implements Api {
  Future<dynamic> buscaPorUId(
    String uId,
  ) async {
    Usuario? user;
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await db.collection("USUARIO").where("UID", isEqualTo: uId).get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        user = await Usuario.fromSnapshot(doc);
      }
      return user;
    } else {
      return null;
    }
  }

  static Future<dynamic> buscaPorUsuario(
    String usuario,
  ) async {
    Usuario? user;
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db
        .collection("USUARIO")
        .where("USUARIO", isEqualTo: usuario)
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        user = await Usuario.fromSnapshot(doc);
      }
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<bool> criar(
    Object objeto,
  ) async {
    Usuario usuario = objeto as Usuario;
    var db = FirebaseFirestore.instance;

    await db.collection("USUARIO").add(usuario.toJson());
    return true;
  }

  @override
  Future<bool> atualizar(
    Object objeto,
  ) async {
    Usuario usuario = objeto as Usuario;
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("USUARIO").doc(usuario.id);

    documentRef.update({
      "USUARIO": usuario.usuario,
      'TELEFONE': usuario.telefone,
      'DATA_NASCIMENTO': usuario.dataNascimento,
      'BIOGRAFIA': usuario.biografia,
      'LOCALIZACAO': usuario.localizacao,
      'SEGUIDORES': usuario.seguidores,
      'SEGUINDO': usuario.seguindo,
      'IMAGEM_USUARIO': usuario.imagemUsuario,
      'IMAGEM_USUARIO_ATUALIZADO': usuario.imagemUsuarioAtualizado,
      'IMAGEM_CAPA': usuario.imagemCapa,
      'IMAGEM_CAPA_ATUALIZADO': usuario.imagemCapaAtualizado,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
    return true;
  }

  @override
  Future<bool> deletar(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }
}
