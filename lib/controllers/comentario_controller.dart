// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/comentario_api.dart';
import 'package:h/models/comentario.dart';
import 'package:h/models/dto/comentario_dto.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';

class ComentarioController extends GetxController {
  final internetController = Internet();

  final ComentarioApi comentarioApi = ComentarioApi();

  RxList<Comentario> listComentarios = RxList<Comentario>();

  Future<bool> criar({
    required Publicacao publicacao,
    required Publicacao resposta,
    required BuildContext context,
  }) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }
    try {
      var db = FirebaseFirestore.instance;

      ComentarioDto comentario = ComentarioDto(
        publicacao: db.doc("PUBLICACAO/${publicacao.id}"),
        resposta: db.doc("PUBLICACAO/${resposta.id}"),
      );

      return await comentarioApi.criar(comentario);
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }

  Future<bool> buscarPorPublicacao(
    Publicacao publicacao,
    BuildContext context,
  ) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }
    listComentarios.clear();
    try {
      listComentarios
          .addAll(await comentarioApi.buscarPorPublicacao(publicacao.id!));
      return true;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(context,
          e.message ?? 'Ocorreu algum erro ao carregar os comentários.');
      return false;
    }
  }
}
