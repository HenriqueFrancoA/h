// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h/apis/like_api.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:h/models/dto/like_dto.dart';
import 'package:h/models/like.dart';
import 'package:h/models/publication.dart';
import 'package:h/models/user.dart';
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

final _publicationController = Get.put(PublicationController());

class LikeController extends GetxController {
  final _internet = Internet();

  final LikeApi _likeApi = LikeApi();

  //Verifica se existe like do 'userLogged' no loginController para atualizar o card do post.
  //Caso 'createDelete' seja verdadeiro significa que o 'userLogged' clicou para curtir e a
  //função irá verificar se já existe curtida ele irá deletar e se não houver ele ir criar.
  Future<bool> checkLikes({
    required User user,
    required Publication publication,
    required bool createDelete,
    required BuildContext context,
  }) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }

    try {
      var db = FirebaseFirestore.instance;

      Like like = Like(
        publication: publication,
        user: user,
      );

      Like? likeFound = await _likeApi.checkLikes(like);

      if (!createDelete) {
        if (likeFound != null) {
          return true;
        } else {
          return false;
        }
      }

      if (likeFound != null) {
        await _likeApi.delete(likeFound.id!);
        publication.likes--;
        await _publicationController.updatePublication(
          publication: publication,
          context: context,
        );
        return true;
      } else {
        LikeDto likeDto = LikeDto(
          user: db.doc("USER/${user.id}"),
          publication: db.doc("PUBLICATION/${publication.id}"),
        );

        bool retorno = await _likeApi.create(likeDto);

        if (retorno) {
          publication.likes++;
          await _publicationController.updatePublication(
            publication: publication,
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
