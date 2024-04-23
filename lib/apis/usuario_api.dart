import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/usuario.dart';

abstract class UsuarioApi {
  static Future<dynamic> buscaPorUId(
    String uId,
  ) async {
    Usuario? user;
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await db.collection("USUARIO").where("UID", isEqualTo: uId).get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> dataUsuario = doc.data() as Map<String, dynamic>;
        user = Usuario(
          id: doc.id,
          uId: dataUsuario["UID"],
          email: dataUsuario["EMAIL"],
          usuario: dataUsuario["USUARIO"],
          telefone: dataUsuario["TELEFONE"],
          senha: dataUsuario["SENHA"],
          dataNascimento: dataUsuario["DATA_NASCIMENTO"],
          dataCriacao: dataUsuario["DATA_CRIACAO"],
          biografia: dataUsuario["BIOGRAFIA"],
          localizacao: dataUsuario["LOCALIZACAO"],
          seguidores: dataUsuario["SEGUIDORES"],
          seguindo: dataUsuario["SEGUINDO"],
          imagemUsuario: dataUsuario["IMAGEM_USUARIO"],
          imagemUsuarioAtualizado: dataUsuario['IMAGEM_USUARIO_ATUALIZADO'],
          imagemCapa: dataUsuario["IMAGEM_CAPA"],
          imagemCapaAtualizado: dataUsuario['IMAGEM_CAPA_ATUALIZADO'],
        );
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
        Map<String, dynamic> dataUsuario = doc.data() as Map<String, dynamic>;
        user = Usuario(
          id: doc.id,
          uId: dataUsuario["UID"],
          email: dataUsuario["EMAIL"],
          usuario: dataUsuario["USUARIO"],
          telefone: dataUsuario["TELEFONE"],
          senha: dataUsuario["SENHA"],
          dataNascimento: dataUsuario["DATA_NASCIMENTO"],
          dataCriacao: dataUsuario["DATA_CRIACAO"],
          biografia: dataUsuario["BIOGRAFIA"],
          localizacao: dataUsuario["LOCALIZACAO"],
          seguidores: dataUsuario["SEGUIDORES"],
          seguindo: dataUsuario["SEGUINDO"],
          imagemUsuario: dataUsuario["IMAGEM_USUARIO"],
          imagemUsuarioAtualizado: dataUsuario['IMAGEM_USUARIO_ATUALIZADO'],
          imagemCapa: dataUsuario["IMAGEM_CAPA"],
          imagemCapaAtualizado: dataUsuario['IMAGEM_CAPA_ATUALIZADO'],
        );
      }
      return user;
    } else {
      return null;
    }
  }

  static Future<bool> criarUsuario(
    Usuario usuario,
  ) async {
    var db = FirebaseFirestore.instance;
    try {
      db.collection("USUARIO").add(usuario.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> atualizarUsuario(
    Usuario usuario,
  ) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("USUARIO").doc(usuario.id);
    try {
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
    } catch (e) {
      return false;
    }
  }
}
