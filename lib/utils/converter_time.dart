import 'package:cloud_firestore/cloud_firestore.dart';

//Faz o cálculo do tempo que passou desde a criação.
String timeSinceCreation(Timestamp dateCreation) {
  DateTime now = DateTime.now();

  DateTime dateCreationDateTime = dateCreation.toDate();

  Duration difference = now.difference(dateCreationDateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seg';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} h';
  } else {
    return '${difference.inDays} d';
  }
}
