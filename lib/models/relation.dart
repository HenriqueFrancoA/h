import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h/models/user.dart';

class Relation {
  String? id;
  late User user;
  late User following;

  Relation({
    this.id,
    required this.user,
    required this.following,
  });

  static Future<Relation> fromSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot userDoc = await doc['USER'].get();
    DocumentSnapshot followingDoc = await doc['FOLLOWING'].get();

    return Relation(
      id: doc.id,
      user: await User.fromSnapshot(userDoc),
      following: await User.fromSnapshot(followingDoc),
    );
  }

  Relation.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['USER']);
    following = User.fromJson(json['FOLLOWING']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER'] = user;
    data['FOLLOWING'] = following;
    return data;
  }
}
