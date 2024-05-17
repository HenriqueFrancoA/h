import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/comment.dart';
import 'package:h/models/dto/comment_dto.dart';

class CommentApi implements Api {
  @override
  Future<bool> update(Object object) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future<bool> create(Object object) async {
    CommentDto comment = object as CommentDto;
    var db = FirebaseFirestore.instance;

    await db.collection("COMMENT").add(comment.toJson());
    return true;
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }

  Future<List<Comment>> searchByPublication(String idPublication) async {
    List<Comment> listComments = [];
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("COMMENT")
        .where("PUBLICATION", isEqualTo: db.doc("PUBLICATION/$idPublication"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Comment? comment;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        comment = await Comment.fromSnapshot(doc);

        listComments.add(comment);
      }
    }

    return listComments;
  }

  Future<Comment?> searchByReply(String idPublication) async {
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("COMMENT")
        .where("REPLY", isEqualTo: db.doc("PUBLICATION/$idPublication"))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Comment? comment;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        comment = await Comment.fromSnapshot(doc);
      }
      return comment;
    }
    return null;
  }
}
