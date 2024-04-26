import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/dto/relacao_dto.dart';
import 'package:h/models/relacao.dart';

class RelacaoApi implements Api {
  @override
  Future<bool> atualizar(Object objeto) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future<bool> criar(Object objeto) async {
    RelacaoDto relacao = objeto as RelacaoDto;
    var db = FirebaseFirestore.instance;

    await db.collection("RELACAO").add(relacao.toJson());

    return true;
  }

  @override
  Future<bool> deletar(String id) async {
    var db = FirebaseFirestore.instance;

    DocumentReference documentRef = db.collection("RELACAO").doc(id);
    await documentRef.delete();
    return true;
  }

  Future<Relacao?> verificaRelacao(Relacao relacao) async {
    var db = FirebaseFirestore.instance;
    Relacao? relacaoEncontrada;

    QuerySnapshot querySnapshot = await db
        .collection("RELACAO")
        .where("SEGUINDO", isEqualTo: db.doc("USUARIO/${relacao.seguindo.id}"))
        .where("USUARIO", isEqualTo: db.doc("USUARIO/${relacao.usuario.id}"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        relacaoEncontrada = await Relacao.fromSnapshot(doc);
        return relacaoEncontrada;
      }
    }
    return relacaoEncontrada;
  }
}
