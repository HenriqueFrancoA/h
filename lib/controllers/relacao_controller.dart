// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/relacao_api.dart';
import 'package:h/controllers/usuario_controller.dart';
import 'package:h/models/dto/relacao_dto.dart';
import 'package:h/models/relacao.dart';
import 'package:h/models/usuario.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';

class RelacaoController extends GetxController {
  final internetController = Internet();

  final RelacaoApi relacaoApi = RelacaoApi();

  final usuarioController = Get.put(UsuarioController());

  Future<bool> verificaSeguir({
    required Usuario seguindo,
    required Usuario usuario,
    required bool criarDeletar,
    required BuildContext context,
  }) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }
    try {
      var db = FirebaseFirestore.instance;

      Relacao relacao = Relacao(
        usuario: usuario,
        seguindo: seguindo,
      );

      Relacao? relacaoEncontrada = await relacaoApi.verificaRelacao(relacao);

      if (!criarDeletar) {
        if (relacaoEncontrada != null) {
          return true;
        } else {
          return false;
        }
      }

      if (relacaoEncontrada != null) {
        await relacaoApi.deletar(relacaoEncontrada.id!);
        usuario.seguindo--;
        await usuarioController.atualizar(
          user: usuario,
          context: context,
        );
        seguindo.seguidores--;
        await usuarioController.atualizar(
          user: seguindo,
          context: context,
        );
        return true;
      } else {
        RelacaoDto relacaoDto = RelacaoDto(
          usuario: db.doc("USUARIO/${usuario.id}"),
          seguindo: db.doc("USUARIO/${seguindo.id}"),
        );
        bool retorno = await relacaoApi.criar(relacaoDto);

        if (retorno) {
          usuario.seguindo++;
          await usuarioController.atualizar(
            user: usuario,
            context: context,
          );
          seguindo.seguidores++;
          await usuarioController.atualizar(
            user: seguindo,
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
