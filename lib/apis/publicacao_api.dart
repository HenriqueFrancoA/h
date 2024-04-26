import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/dto/publicacao_dto.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/models/usuario.dart';

class PublicacaoApi implements Api {
  @override
  Future<bool> atualizar(Object objeto) async {
    Publicacao publicacao = objeto as Publicacao;
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef =
        db.collection("PUBLICACAO").doc(publicacao.id);
    await documentRef.update({
      'CURTIDAS': publicacao.curtidas.value,
      'COMENTARIOS': publicacao.comentarios.value,
      'COMPARTILHAMENTOS': publicacao.compartilhamentos.value,
    });
    return true;
  }

  @override
  Future<String> criar(Object objeto) async {
    PublicacaoDto publicacao = objeto as PublicacaoDto;
    var db = FirebaseFirestore.instance;

    DocumentReference docRef =
        await db.collection("PUBLICACAO").add(publicacao.toJson());

    String id = docRef.id;

    return id;
  }

  @override
  Future<bool> deletar(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }

  Future<List<Publicacao>> buscarTodas(Publicacao? publicacao) async {
    var db = FirebaseFirestore.instance;

    List<Publicacao> publicacoes = [];

    QuerySnapshot querySnapshot = await db
        .collection("PUBLICACAO")
        .orderBy("DATA_CRIACAO", descending: true)
        // .startAt([publicacao])
        .limit(15)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Publicacao? publicacao;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        publicacao = await Publicacao.fromSnapshot(doc);

        publicacoes.add(publicacao);
      }
    }

    return publicacoes;
  }

  Future<List<Publicacao>> buscarPorUsuario(Usuario usuario, int pagina) async {
    var db = FirebaseFirestore.instance;

    List<Publicacao> publicacoes = [];

    // int startIndex = pagina * 15;

    QuerySnapshot querySnapshot = await db
        .collection("PUBLICACAO")
        .where("USUARIO", isEqualTo: db.doc("USUARIO/${usuario.id}"))
        .orderBy("DATA_CRIACAO", descending: true)
        // .startAt([startIndex])
        .limit(15)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Publicacao? publicacao;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        publicacao = await Publicacao.fromSnapshot(doc);

        publicacoes.add(publicacao);
      }
    }

    return publicacoes;
  }
}
