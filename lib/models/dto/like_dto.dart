import 'package:cloud_firestore/cloud_firestore.dart';

class LikeDto {
  late DocumentReference<Map<String, dynamic>>? user;
  late DocumentReference<Map<String, dynamic>>? publication;

  LikeDto({
    required this.user,
    required this.publication,
  });

  LikeDto.fromJson(Map<String, dynamic> json) {
    user = json['USER'];
    publication = json['PUBLICATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER'] = user;
    data['PUBLICATION'] = publication;
    return data;
  }
}
