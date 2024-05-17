import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/dto/relation_dto.dart';
import 'package:h/models/relation.dart';
import 'package:h/models/user.dart';

class RelationApi implements Api {
  var db = FirebaseFirestore.instance;

  @override
  Future<bool> update(Object objeto) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future<bool> create(Object object) async {
    RelationDto relation = object as RelationDto;

    await db.collection("RELATION").add(relation.toJson());

    return true;
  }

  @override
  Future<bool> delete(String id) async {
    DocumentReference documentRef = db.collection("RELATION").doc(id);
    await documentRef.delete();
    return true;
  }

  Future<Relation?> checkRelation(Relation relation) async {
    Relation? relationFound;

    QuerySnapshot querySnapshot = await db
        .collection("RELATION")
        .where("FOLLOWING", isEqualTo: db.doc("USER/${relation.following.id}"))
        .where("USER", isEqualTo: db.doc("USER/${relation.user.id}"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        relationFound = await Relation.fromSnapshot(doc);
        return relationFound;
      }
    }
    return relationFound;
  }

  Future<List<Relation>> searchByFollower(User user) async {
    QuerySnapshot querySnapshot = await db
        .collection("RELATION")
        .where("FOLLOWING", isEqualTo: db.doc("USER/${user.id}"))
        .get();

    List<Relation>? listRelations = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        listRelations.add(await Relation.fromSnapshot(doc));
      }
    }
    return listRelations;
  }

  Future<List<Relation>> searchByFollowing(User user) async {
    QuerySnapshot querySnapshot = await db
        .collection("RELATION")
        .where("USER", isEqualTo: db.doc("USER/${user.id}"))
        .get();

    List<Relation>? listRelations = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        listRelations.add(await Relation.fromSnapshot(doc));
      }
    }
    return listRelations;
  }
}
