import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/apis/api.dart';
import 'package:h/models/dto/publication_dto.dart';
import 'package:h/models/publication.dart';
import 'package:h/models/user.dart';

class PublicationApi implements Api {
  int pageSize = 15;

  @override
  Future<bool> update(Object object) async {
    Publication publication = object as Publication;
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef =
        db.collection("PUBLICATION").doc(publication.id);
    await documentRef.update({
      'LIKES': publication.likes.value,
      'COMMENTS': publication.comments.value,
      'SHARINGS': publication.sharings.value,
    });
    return true;
  }

  @override
  Future<String> create(Object objeto) async {
    PublicationDto publication = objeto as PublicationDto;
    var db = FirebaseFirestore.instance;

    DocumentReference docRef =
        await db.collection("PUBLICATION").add(publication.toJson());

    String id = docRef.id;

    return id;
  }

  @override
  Future<bool> delete(String id) async {
    var db = FirebaseFirestore.instance;

    DocumentReference documentRef = db.collection("PUBLICATION").doc(id);
    await documentRef.update({
      'DISABLED': true,
    });

    return true;
  }

  Future<List<Publication>> searchAll(Publication? publi) async {
    var db = FirebaseFirestore.instance;

    List<Publication> listPublications = [];

    QuerySnapshot? querySnapshot;
    if (publi != null) {
      querySnapshot = await db
          .collection("PUBLICATION")
          .where("DISABLED", isEqualTo: false)
          .orderBy("CREATION_DATE", descending: true)
          .startAfter([publi.creationDate])
          .limit(pageSize)
          .get();
    } else {
      querySnapshot = await db
          .collection("PUBLICATION")
          .where("DISABLED", isEqualTo: false)
          .orderBy("CREATION_DATE", descending: true)
          .limit(pageSize)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      Publication? publication;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        publication = await Publication.fromSnapshot(doc);

        listPublications.add(publication);
      }
    }

    return listPublications;
  }

  Future<List<Publication>> searchByUser(Publication? publi, User user) async {
    var db = FirebaseFirestore.instance;

    List<Publication> listPublications = [];

    QuerySnapshot? querySnapshot;

    if (publi != null) {
      Timestamp creationDate =
          Timestamp.fromDate(publi.creationDate.toDate().add(
                const Duration(
                  seconds: 1,
                ),
              ));
      querySnapshot = await db
          .collection("PUBLICATION")
          .where("USER", isEqualTo: db.doc("USER/${user.id}"))
          .where("DISABLED", isEqualTo: false)
          .orderBy("CREATION_DATE", descending: true)
          .startAt([creationDate])
          .limit(pageSize)
          .get();
    } else {
      querySnapshot = await db
          .collection("PUBLICATION")
          .where("USER", isEqualTo: db.doc("USER/${user.id}"))
          .where("DISABLED", isEqualTo: false)
          .orderBy("CREATION_DATE", descending: true)
          .limit(pageSize)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      Publication? publication;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        publication = await Publication.fromSnapshot(doc);

        listPublications.add(publication);
      }
    }

    return listPublications;
  }

  Future<List<Publication>> searchByUserNoLimit(User user) async {
    var db = FirebaseFirestore.instance;

    List<Publication> listPublications = [];

    QuerySnapshot? querySnapshot;

    querySnapshot = await db
        .collection("PUBLICATION")
        .where("USER", isEqualTo: db.doc("USER/${user.id}"))
        .where("DISABLED", isEqualTo: false)
        .orderBy("CREATION_DATE", descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Publication? publication;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        publication = await Publication.fromSnapshot(doc);

        listPublications.add(publication);
      }
    }

    return listPublications;
  }

  Future<List<Publication>> searchContainsText(String text) async {
    var db = FirebaseFirestore.instance;

    List<Publication> listPublications = [];

    QuerySnapshot? querySnapshot;

    querySnapshot = await db
        .collection("PUBLICATION")
        .where("DISABLED", isEqualTo: false)
        .orderBy("CREATION_DATE", descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Publication? publication;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        publication = await Publication.fromSnapshot(doc);
        if (publication.text != null &&
            publication.text!.toLowerCase().contains(text.toLowerCase())) {
          listPublications.add(publication);
        }
      }
    }

    return listPublications;
  }

  Future<Publication?> searchById(String id) async {
    Publication? publication;

    var db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("PUBLICATION").doc(id).get();

    if (snapshot.exists) {
      publication = await Publication.fromSnapshot(snapshot);
    }

    return publication;
  }
}
