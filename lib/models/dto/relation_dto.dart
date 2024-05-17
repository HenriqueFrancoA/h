import 'package:cloud_firestore/cloud_firestore.dart';

class RelationDto {
  DocumentReference<Map<String, dynamic>>? user;
  DocumentReference<Map<String, dynamic>>? following;

  RelationDto({
    required this.user,
    required this.following,
  });

  RelationDto.fromJson(Map<String, dynamic> json) {
    user = json['USER'];
    following = json['FOLLOWING'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER'] = user;
    data['FOLLOWING'] = following;
    return data;
  }
}
