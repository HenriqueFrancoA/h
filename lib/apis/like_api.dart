import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/like.dart';
import 'package:h/models/dto/like_dto.dart';

class LikeApi implements Api {
  @override
  Future<bool> update(Object object) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future create(Object object) async {
    LikeDto like = object as LikeDto;
    var db = FirebaseFirestore.instance;

    await db.collection("LIKE").add(like.toJson());
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    var db = FirebaseFirestore.instance;

    DocumentReference documentRef = db.collection("LIKE").doc(id);
    await documentRef.delete();
    return true;
  }

  Future<Like?> checkLikes(Like like) async {
    var db = FirebaseFirestore.instance;
    Like? likeFound;

    QuerySnapshot querySnapshot = await db
        .collection("LIKE")
        .where("PUBLICATION",
            isEqualTo: db.doc("PUBLICATION/${like.publication.id}"))
        .where("USER", isEqualTo: db.doc("USER/${like.user.id}"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        likeFound = await Like.fromSnapshot(doc);
        return likeFound;
      }
    }
    return likeFound;
  }
}
