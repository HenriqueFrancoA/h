import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/publication.dart';

class Sharing {
  String? id;
  late Publication publication;

  Sharing({
    this.id,
    required this.publication,
  });

  static Future<Sharing> fromSnapshot(
    DocumentSnapshot doc,
  ) async {
    DocumentSnapshot? publicationDoc;
    publicationDoc = await doc['PUBLICATION'].get();

    return Sharing(
      id: doc.id,
      publication: await Publication.fromSnapshot(publicationDoc!),
    );
  }

  Sharing.fromJson(Map<String, dynamic> json) {
    publication = Publication.fromJson(json['PUBLICATION']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICATION'] = publication;
    return data;
  }
}
