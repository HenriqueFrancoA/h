import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class User extends Object {
  String? id;
  String? uId;
  late String email;
  late String userName;
  String? telephone;
  late String password;
  late Timestamp dateBirth;
  late Timestamp creationDate;
  String? biography;
  String? location;
  late RxInt followers;
  late RxInt following;
  late bool userImage;
  late int updatedUserImage;
  late bool coverImage;
  late int updatedCoverImage;
  late bool disabled;

  User({
    this.id,
    this.uId,
    required this.email,
    required this.userName,
    this.telephone,
    required this.password,
    required this.dateBirth,
    required this.creationDate,
    this.biography,
    this.location,
    required this.followers,
    required this.following,
    required this.userImage,
    required this.updatedUserImage,
    required this.coverImage,
    required this.updatedCoverImage,
    required this.disabled,
  });

  static Future<User> fromSnapshot(DocumentSnapshot snapshot) async {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      uId: data['UID'],
      email: data['EMAIL'],
      userName: data['USER_NAME'],
      telephone: data['TELEPHONE'],
      password: data['PASSWORD'],
      dateBirth: data['DATE_BIRTH'],
      creationDate: data['CREATION_DATE'],
      biography: data['BIOGRAPHY'],
      location: data['LOCATION'],
      followers: RxInt(data['FOLLOWERS']),
      following: RxInt(data['FOLLOWING']),
      userImage: data['USER_IMAGE'],
      updatedUserImage: data['UPDATED_USER_IMAGE'],
      coverImage: data['COVER_IMAGE'],
      updatedCoverImage: data['UPDATED_COVER_IMAGE'],
      disabled: data['DISABLED'],
    );
  }

  User.fromJson(Map<String, dynamic> json) {
    uId = json['UID'];
    email = json['EMAIL'] ?? '';
    userName = json['USER_NAME'] ?? '';
    telephone = json['TELEPHONE'];
    password = json['PASSWORD'] ?? '';
    dateBirth = json['DATE_BIRTH'] ?? Timestamp.now();
    creationDate = json['CREATION_DATE'] ?? Timestamp.now();
    biography = json['BIOGRAPHY'];
    location = json['LOCATION'];
    followers = json['FOLLOWERS'] ?? 0;
    following = json['FOLLOWING'] ?? 0;
    userImage = json['USER_IMAGE'] ?? false;
    updatedUserImage = json['UPDATED_USER_IMAGE'] ?? 0;
    coverImage = json['COVER_IMAGE'] ?? false;
    updatedCoverImage = json['UPDATED_COVER_IMAGE'] ?? 0;
    disabled = json['DISABLED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UID'] = uId;
    data['EMAIL'] = email;
    data['USER_NAME'] = userName;
    data['TELEPHONE'] = telephone;
    data['PASSWORD'] = password;
    data['DATE_BIRTH'] = dateBirth;
    data['CREATION_DATE'] = creationDate;
    data['BIOGRAPHY'] = biography;
    data['LOCATION'] = location;
    data['FOLLOWERS'] = followers.value;
    data['FOLLOWING'] = following.value;
    data['USER_IMAGE'] = userImage;
    data['UPDATED_USER_IMAGE'] = updatedUserImage;
    data['COVER_IMAGE'] = coverImage;
    data['UPDATED_COVER_IMAGE'] = updatedCoverImage;
    data['DISABLED'] = disabled;
    return data;
  }
}
