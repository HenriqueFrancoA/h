import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/dto/sharing_dto.dart';

class SharingApi implements Api {
  @override
  Future<bool> update(Object object) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future create(Object object) async {
    SharingDto sharingDto = object as SharingDto;
    var db = FirebaseFirestore.instance;

    DocumentReference docRef =
        await db.collection("SHARING").add(sharingDto.toJson());

    String id = docRef.id;

    return id;
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }
}
