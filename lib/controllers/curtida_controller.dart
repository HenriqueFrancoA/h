// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/curtida_api.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:h/models/curtida.dart';
import 'package:h/models/dto/curtida_dto.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/models/usuario.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';

class CurtidaController extends GetxController {
  final internetController = Internet();

  final CurtidaApi curtidaApi = CurtidaApi();

  final publicacaoController = Get.put(PublicacaoController());

  Future<bool> verificaCurtida({
    required Usuario usuario,
    required Publicacao publicacao,
    required bool criarDeletar,
    required BuildContext context,
  }) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }

    try {
      var db = FirebaseFirestore.instance;

      Curtida curtida = Curtida(
        publicacao: publicacao,
        usuario: usuario,
      );

      Curtida? curtidaEncontrada = await curtidaApi.verificaCurtida(curtida);

      if (!criarDeletar) {
        if (curtidaEncontrada != null) {
          return true;
        } else {
          return false;
        }
      }

      if (curtidaEncontrada != null) {
        await curtidaApi.deletar(curtidaEncontrada.id!);
        publicacao.curtidas--;
        await publicacaoController.atualizar(
          publicacao: publicacao,
          context: context,
        );
        return true;
      } else {
        CurtidaDto curtidaDto = CurtidaDto(
          usuario: db.doc("USUARIO/${usuario.id}"),
          publicacao: db.doc("PUBLICACAO/${publicacao.id}"),
        );

        bool retorno = await curtidaApi.criar(curtidaDto);

        if (retorno) {
          publicacao.curtidas++;
          await publicacaoController.atualizar(
            publicacao: publicacao,
            context: context,
          );
          return true;
        }
        return false;
      }
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }
}
