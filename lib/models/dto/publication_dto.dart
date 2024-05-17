import 'package:cloud_firestore/cloud_firestore.dart';

class PublicationDto {
  DocumentReference<Map<String, dynamic>>? user;
  DocumentReference<Map<String, dynamic>>? sharing;
  String? text;
  late bool image;
  late bool comment;
  late Timestamp creationDate;
  late int likes;
  late int comments;
  late int sharings;
  late bool disabled;

  PublicationDto({
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

  PublicationDto.fromJson(Map<String, dynamic> json) {
    user = json['USER'];
    sharing = json['SHARING'];
    text = json['TEXT'];
    image = json['IMAGE'];
    comment = json['COMMENT'];
    creationDate = json['CREATION_DATE'];
    likes = json['LIKES'];
    comments = json['COMMENTS'];
    sharing = json['SHARINGS'];
    disabled = json['DISABLED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER'] = user;
    data['SHARING'] = sharing;
    data['TEXT'] = text;
    data['IMAGE'] = image;
    data['COMMENT'] = comment;
    data['CREATION_DATE'] = creationDate;
    data['LIKES'] = likes;
    data['COMMENTS'] = comments;
    data['SHARINGS'] = sharings;
    data['DISABLED'] = disabled;
    return data;
  }
}
