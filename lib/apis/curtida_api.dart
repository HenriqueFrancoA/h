import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/curtida.dart';
import 'package:h/models/dto/curtida_dto.dart';

class CurtidaApi implements Api {
  @override
  Future<bool> atualizar(Object objeto) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future criar(Object objeto) async {
    CurtidaDto curtida = objeto as CurtidaDto;
    var db = FirebaseFirestore.instance;

    await db.collection("CURTIDA").add(curtida.toJson());
    return true;
  }

  @override
  Future<bool> deletar(String id) async {
    var db = FirebaseFirestore.instance;

    DocumentReference documentRef = db.collection("CURTIDA").doc(id);
    await documentRef.delete();
    return true;
  }

  Future<Curtida?> verificaCurtida(Curtida curtida) async {
    var db = FirebaseFirestore.instance;
    Curtida? curtidaEncontrada;

    QuerySnapshot querySnapshot = await db
        .collection("CURTIDA")
        .where("PUBLICACAO",
            isEqualTo: db.doc("PUBLICACAO/${curtida.publicacao.id}"))
        .where("USUARIO", isEqualTo: db.doc("USUARIO/${curtida.usuario.id}"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        curtidaEncontrada = await Curtida.fromSnapshot(doc);
        return curtidaEncontrada;
      }
    }
    return curtidaEncontrada;
  }
}
