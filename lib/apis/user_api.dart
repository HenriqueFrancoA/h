import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/user.dart';

class UserApi implements Api {
  int pageSize = 10;

  Future<dynamic> searchByUId(
    String uId,
  ) async {
    User? user;
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await db.collection("USER").where("UID", isEqualTo: uId).get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        user = await User.fromSnapshot(doc);
      }
      return user;
    } else {
      return null;
    }
  }

  Future<dynamic> searchByUsername(
    String userName,
  ) async {
    User? user;
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db
        .collection("USER")
        .where("USER_NAME", isEqualTo: userName)
        .where("DISABLED", isEqualTo: false)
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        user = await User.fromSnapshot(doc);
      }
      return user;
    } else {
      return null;
    }
  }

  Future<List<User>> searchContainsUsername(String userName) async {
    List<User> users = [];
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await db.collection("USER").get();

    if (snapshot.docs.isNotEmpty) {
      User user;
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        user = await User.fromSnapshot(doc);
        if (user.userName.toLowerCase().contains(userName.toLowerCase()) &&
            user.disabled == false) {
          users.add(user);
        }
      }
    }
    return users;
  }

  Future<List<User>> searchAll(User? user) async {
    var db = FirebaseFirestore.instance;

    List<User> listUsers = [];

    QuerySnapshot? querySnapshot;

    if (user != null) {
      querySnapshot = await db
          .collection("USER")
          .where("DISABLED", isEqualTo: false)
          .orderBy("FOLLOWERS", descending: true)
          .startAfter([user.followers])
          .limit(pageSize)
          .get();
    } else {
      querySnapshot = await db
          .collection("USER")
          .where("DISABLED", isEqualTo: false)
          .orderBy("FOLLOWERS", descending: true)
          .limit(pageSize)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      User? userFound;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        userFound = await User.fromSnapshot(doc);

        listUsers.add(userFound);
      }
    }

    return listUsers;
  }

  @override
  Future<bool> create(
    Object object,
  ) async {
    User user = object as User;
    var db = FirebaseFirestore.instance;

    await db.collection("USER").add(user.toJson());
    return true;
  }

  @override
  Future<bool> update(
    Object object,
  ) async {
    User user = object as User;
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("USER").doc(user.id);

    documentRef.update({
      "USER_NAME": user.userName,
      'TELEPHONE': user.telephone,
      'DATE_BIRTH': user.dateBirth,
      'BIOGRAPHY': user.biography,
      'LOCATION': user.location,
      'FOLLOWERS': user.followers,
      'FOLLOWING': user.following,
      'USER_IMAGE': user.userImage,
      'UPDATED_USER_IMAGE': user.updatedUserImage,
      'COVER_IMAGE': user.coverImage,
      'UPDATED_COVER_IMAGE': user.updatedCoverImage,
      'DISABLED': user.disabled,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
    return true;
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement deletar
    throw UnimplementedError();
  }
}
