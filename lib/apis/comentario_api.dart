import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/comentario.dart';
import 'package:h/models/dto/comentario_dto.dart';

class ComentarioApi implements Api {
  @override
  Future<bool> atualizar(Object objeto) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future<bool> criar(Object objeto) async {
    ComentarioDto comentario = objeto as ComentarioDto;
    var db = FirebaseFirestore.instance;

    await db.collection("COMENTARIO").add(comentario.toJson());
    return true;
  }

  @override
  Future<bool> deletar(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }

  Future<List<Comentario>> buscarPorPublicacao(String idPublicacao) async {
    List<Comentario> listaComentarios = [];
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("COMENTARIO")
        .where("PUBLICACAO", isEqualTo: db.doc("PUBLICACAO/$idPublicacao"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Comentario? comentario;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        comentario = await Comentario.fromSnapshot(doc);

        listaComentarios.add(comentario);
      }
    }

    return listaComentarios;
  }
}
