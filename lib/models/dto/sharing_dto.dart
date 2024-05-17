import 'package:cloud_firestore/cloud_firestore.dart';

class SharingDto {
  late DocumentReference<Map<String, dynamic>>? publication;

  SharingDto({
    required this.publication,
  });

  SharingDto.fromJson(Map<String, dynamic> json) {
    publication = json['PUBLICATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PUBLICATION'] = publication;
    return data;
  }
}
