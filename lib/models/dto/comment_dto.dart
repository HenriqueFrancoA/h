import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  DocumentReference<Map<String, dynamic>>? publication;
  DocumentReference<Map<String, dynamic>>? reply;

  CommentDto({
    required this.publication,
    required this.reply,
  });

  CommentDto.fromJson(Map<String, dynamic> json) {
    publication = json['PUBLICATION'];
    reply = json['REPLY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICATION'] = publication;
    data['REPLY'] = reply;
    return data;
  }
}
