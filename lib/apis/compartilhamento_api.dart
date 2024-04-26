import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/dto/compartilhamento_dto.dart';

class CompartilhamentoApi implements Api {
  @override
  Future<bool> atualizar(Object objeto) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future criar(Object objeto) async {
    CompartilhamentoDto compartilhamentoDto = objeto as CompartilhamentoDto;
    var db = FirebaseFirestore.instance;

    DocumentReference docRef = await db
        .collection("COMPARTILHAMENTO")
        .add(compartilhamentoDto.toJson());

    String id = docRef.id;

    return id;
  }

  @override
  Future<bool> deletar(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }
}
