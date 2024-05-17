import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/publication.dart';

class Comment {
  String? id;
  late Publication publication;
  late Publication reply;

  Comment({
    this.id,
    required this.publication,
    required this.reply,
  });

  static Future<Comment> fromSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot publicationDoc = await doc['PUBLICATION'].get();
    DocumentSnapshot replyDoc = await doc['REPLY'].get();

    return Comment(
      id: doc.id,
      publication: await Publication.fromSnapshot(publicationDoc),
      reply: await Publication.fromSnapshot(replyDoc),
    );
  }

  Comment.fromJson(Map<String, dynamic> json) {
    publication = Publication.fromJson(json['PUBLICATION']);
    reply = Publication.fromJson(json['REPLY']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICATION'] = publication;
    data['REPLY'] = reply;
    return data;
  }
}
