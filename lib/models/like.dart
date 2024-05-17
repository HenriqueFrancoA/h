import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/publication.dart';
import 'package:h/models/user.dart';

class Like {
  String? id;
  late User user;
  late Publication publication;

  Like({
    this.id,
    required this.user,
    required this.publication,
  });

  static Future<Like> fromSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot userDoc = await doc['USER'].get();
    DocumentSnapshot publicationDoc = await doc['PUBLICATION'].get();

    return Like(
      id: doc.id,
      user: await User.fromSnapshot(userDoc),
      publication: await Publication.fromSnapshot(publicationDoc),
    );
  }

  Like.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['USER']);
    publication = Publication.fromJson(json['PUBLICATION']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER'] = user;
    data['PUBLICATION'] = publication;
    return data;
  }
}
