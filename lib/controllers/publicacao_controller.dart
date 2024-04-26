// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/publicacao_api.dart';
import 'package:h/controllers/comentario_controller.dart';
import 'package:h/controllers/compartilhamento_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/models/compartilhamento.dart';
import 'package:h/models/dto/publicacao_dto.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/models/usuario.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';

class PublicacaoController extends GetxController {
  final internetController = Internet();

  final loginController = Get.put(LoginController());
  final comentarioController = Get.put(ComentarioController());
  final compartilhamentoController = Get.put(CompartilhamentoController());

  RxList<Publicacao> listPublicacao = RxList<Publicacao>();

  final PublicacaoApi publicacaoApi = PublicacaoApi();

  Future<bool> criar({
    required Usuario usuario,
    required bool imagem,
    required BuildContext context,
    Publicacao? publicacaoCompartilhada,
    String? texto,
    Publicacao? comentando,
  }) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }
    try {
      if ((texto == null && !imagem) ||
          texto != null && texto.isEmpty && !imagem) {
        NotificationSnackbar.showError(
            context, 'Escreva algo ou anexe uma imagem.');
        return false;
      }
      var db = FirebaseFirestore.instance;

      Compartilhamento? compartilhamento;
      if (publicacaoCompartilhada != null) {
        compartilhamento = await compartilhamentoController.criar(
          publicacao: publicacaoCompartilhada,
          context: context,
        );
        publicacaoCompartilhada.compartilhamentos++;
        await atualizar(
          publicacao: publicacaoCompartilhada,
          context: context,
        );
      }

      PublicacaoDto publicacao = PublicacaoDto(
        usuario: db.doc("USUARIO/${usuario.id}"),
        imagem: imagem,
        texto: texto,
        comentario: false,
        compartilhamento: compartilhamento != null
            ? db.doc("COMPARTILHAMENTO/${compartilhamento.id}")
            : null,
        dataCriacao: Timestamp.now(),
        curtidas: 0,
        comentarios: 0,
        compartilhamentos: 0,
      );

      String idPublicacao = await publicacaoApi.criar(publicacao);

      if (idPublicacao != '') {
        Publicacao publi = Publicacao(
          id: idPublicacao,
          usuario: usuario,
          imagem: imagem,
          comentario: comentando != null ? true : false,
          texto: texto,
          compartilhamento: compartilhamento,
          dataCriacao: Timestamp.now(),
          curtidas: 0.obs,
          comentarios: 0.obs,
          compartilhamentos: 0.obs,
        );
        listPublicacao.insert(0, publi);
        if (comentando != null) {
          bool resposta = await comentarioController.criar(
            publicacao: comentando,
            resposta: publi,
            context: context,
          );
          if (resposta) {
            comentando.comentarios++;
            return await publicacaoApi.atualizar(comentando);
          } else {
            NotificationSnackbar.showError(context, 'Ocorreu algum erro.');
            return false;
          }
        }
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }

  Future<bool> atualizar({
    required Publicacao publicacao,
    required BuildContext context,
  }) async {
    try {
      return await publicacaoApi.atualizar(publicacao);
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }

  Future<List<Publicacao>?> buscarTodas(
    Publicacao? publicacao,
    BuildContext context,
  ) async {
    listPublicacao.clear();
    if (!await internetController.verificaConexao(context)) {
      return listPublicacao;
    }

    try {
      listPublicacao.addAll(await publicacaoApi.buscarTodas(publicacao));
      return listPublicacao;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return null;
    }
  }

  Future<List<Publicacao>?> buscarPorUsuario(
    Usuario usuario,
    int pagina,
    BuildContext context,
  ) async {
    List<Publicacao> listaPublicacao = [];
    if (!await internetController.verificaConexao(context)) {
      return listaPublicacao;
    }

    try {
      listaPublicacao.addAll(await publicacaoApi.buscarPorUsuario(usuario, 1));
      return listaPublicacao;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return null;
    }
  }
}
