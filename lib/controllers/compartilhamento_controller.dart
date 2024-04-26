// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/compartilhamento_api.dart';
import 'package:h/models/compartilhamento.dart';
import 'package:h/models/dto/compartilhamento_dto.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';

class CompartilhamentoController extends GetxController {
  final internetController = Internet();

  final CompartilhamentoApi compartilhamentoApi = CompartilhamentoApi();

  Future<Compartilhamento?> criar({
    required Publicacao publicacao,
    required BuildContext context,
  }) async {
    if (!await internetController.verificaConexao(context)) {
      return null;
    }

    try {
      var db = FirebaseFirestore.instance;

      CompartilhamentoDto compartilhamentoDto = CompartilhamentoDto(
        publicacao: db.doc("PUBLICACAO/${publicacao.id}"),
      );

      String id = await compartilhamentoApi.criar(compartilhamentoDto);

      if (id != '') {
        Compartilhamento compartilhamento = Compartilhamento(
          id: id,
          publicacao: publicacao,
        );
        return compartilhamento;
      }
      return null;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return null;
    }
  }
}
