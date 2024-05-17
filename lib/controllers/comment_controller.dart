// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h/apis/comment_api.dart';
import 'package:h/models/comment.dart';
import 'package:h/models/dto/comment_dto.dart';
import 'package:h/models/publication.dart';
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

class CommentController extends GetxController {
  final _internet = Internet();

  final CommentApi _commentApi = CommentApi();

  RxMap<String, RxList<Comment>> mapPublicationComments =
      RxMap<String, RxList<Comment>>();

  //Cria um novo 'Comment'.
  Future<bool> create({
    required String idPublication,
    required String idReply,
    required BuildContext context,
  }) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      var db = FirebaseFirestore.instance;

      //db.doc() é usado  para passar uma variável como referência no firebase,
      //onde 'PUBLICATION' é a tabela e 'publication.id' é objeto.
      CommentDto comment = CommentDto(
        publication: db.doc("PUBLICATION/$idPublication"),
        reply: db.doc("PUBLICATION/$idReply"),
      );

      return await _commentApi.create(comment);
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }

  //Limpa a lista de 'Comment' e busca todos 'Comments' a partir da 'publication'
  // e adiciona ao um mapa chaveado pelo 'id' de 'publication'.
  //Utilizado para carregar os 'Comments' de uma 'Publication' na tela "PublicationScreen".
  Future<bool> searchByPublication(
    Publication publication,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      RxList<Comment> listComments = RxList();
      if (mapPublicationComments.containsKey(publication.id)) {
        mapPublicationComments[publication.id]!.clear();
      }
      listComments
          .addAll(await _commentApi.searchByPublication(publication.id!));
      mapPublicationComments[publication.id!] = listComments;
      return true;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(context,
          e.message ?? 'Ocorreu algum erro ao carregar os comentários.');
      return false;
    }
  }

  //Busca o 'Comment' a partir da 'reply'.
  //Utilizado para descobrir qual a 'publication' que a 'reply' está respondendo
  //e poder criar a tela em "PublicationScreen".
  Future<Comment?> searchByReply(
    Publication reply,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }
    try {
      return await _commentApi.searchByReply(reply.id!);
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(context,
          e.message ?? 'Ocorreu algum erro ao carregar os comentários.');
      return null;
    }
  }
}
