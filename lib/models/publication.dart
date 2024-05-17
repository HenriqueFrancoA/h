import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:h/models/sharing.dart';
import 'package:h/models/user.dart';

class Publication {
  String? id;
  late User user;
  Sharing? sharing;
  String? text;
  late bool image;
  late bool comment;
  late Timestamp creationDate;
  late RxInt likes;
  late RxInt comments;
  late RxInt sharings;
  late bool disabled;

  Publication({
    this.id,
    required this.user,
    this.sharing,
    this.text,
    required this.image,
    required this.comment,
    required this.creationDate,
    required this.likes,
    required this.comments,
    required this.sharings,
    required this.disabled,
  });

  static Future<Publication> fromSnapshot(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    DocumentSnapshot userDoc = await doc['USER'].get();
    DocumentSnapshot? sharingDoc;

    if (doc['SHARING'] != null) {
      sharingDoc = await doc['SHARING'].get();
    }

    return Publication(
      id: doc.id,
      user: await User.fromSnapshot(userDoc),
      sharing:
          sharingDoc != null ? await Sharing.fromSnapshot(sharingDoc) : null,
      text: data['TEXT'].trim(),
      image: data['IMAGE'],
      comment: data['COMMENT'],
      creationDate: data['CREATION_DATE'],
      likes: RxInt(data['LIKES']),
      comments: RxInt(data['COMMENTS']),
      sharings: RxInt(data['SHARINGS']),
      disabled: data['DISABLED'],
    );
  }

  Publication.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['USER']);
    sharing = Sharing.fromJson(json['SHARING']);
    text = json['TEXT'].trim();
    image = json['IMAGE'];
    comment = json['COMMENT'];
    creationDate = json['CREATION_DATE'];
    likes = json['LIKES'];
    comments = json['COMMENTS'];
    sharings = json['SHARINGS'];
    disabled = json['DISABLED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER'] = user;
    data['SHARING'] = sharing;
    data['TEXT'] = text!.trim();
    data['IMAGE'] = image;
    data['COMMENT'] = comment;
    data['CREATION_DATE'] = creationDate;
    data['LIKES'] = likes.value;
    data['COMMENTS'] = comments.value;
    data['SHARINGS'] = sharings.value;
    data['DISABLED'] = disabled;
    return data;
  }
}
