import 'package:cloud_firestore/cloud_firestore.dart';

String tempoDesdeCriacao(Timestamp dataCriacao) {
  DateTime agora = DateTime.now();

  DateTime dataCriacaoDateTime = dataCriacao.toDate();

  Duration diferenca = agora.difference(dataCriacaoDateTime);

  if (diferenca.inSeconds < 60) {
    return '${diferenca.inSeconds} seg';
  } else if (diferenca.inMinutes < 60) {
    return '${diferenca.inMinutes} min';
  } else if (diferenca.inHours < 24) {
    return '${diferenca.inHours} h';
  } else {
    return '${diferenca.inDays} d';
  }
}
