// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h/apis/publication_api.dart';
import 'package:h/controllers/comment_controller.dart';
import 'package:h/controllers/sharing_controller.dart';
import 'package:h/models/dto/publication_dto.dart';
import 'package:h/models/publication.dart';
import 'package:h/models/sharing.dart';
import 'package:h/models/user.dart';
import 'package:h/utils/image_configs.dart';
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

final _commentController = Get.put(CommentController());
final _sharingController = Get.put(SharingController());

class PublicationController extends GetxController {
  final _internet = Internet();

  RxList<Publication> listPublication = RxList<Publication>();
  RxList<Publication> listPublicationsFound = RxList<Publication>();
  RxList<Publication> listAuxPublication = RxList<Publication>();
  RxMap<String, RxList<Publication>> mapUserPublication =
      RxMap<String, RxList<Publication>>();
  RxMap<String, bool> finalListUser = RxMap<String, bool>();
  RxBool finalList = RxBool(false);

  final PublicationApi _publicationApi = PublicationApi();

  //Cria uma nova 'publication'.
  Future<bool> create({
    required User user,
    required bool image,
    required BuildContext context,
    Publication? sharedPublication,
    String? text,
    Publication? commenting,
    String? imagePath,
  }) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      if ((text == null && !image) || text != null && text.isEmpty && !image) {
        NotificationSnackbar.showError(
          context,
          'Escreva algo ou anexe uma imagem.',
        );
        return false;
      }
      var db = FirebaseFirestore.instance;

      //Caso sharedPublication for diferente de null irá criar uma variável tipo 'Sharing' para ser
      //associado a nova 'Publication' que será criada logo em seguida.
      Sharing? sharing;
      if (sharedPublication != null) {
        sharing = await _sharingController.create(
          publication: sharedPublication,
          context: context,
        );
        sharedPublication.sharings++;
        await updatePublication(
          publication: sharedPublication,
          context: context,
        );
      }

      PublicationDto publication = PublicationDto(
        user: db.doc("USER/${user.id}"),
        image: image,
        comment: commenting != null ? true : false,
        text: text != null ? text.trim() : text,
        sharing: sharing != null ? db.doc("SHARING/${sharing.id}") : null,
        creationDate: Timestamp.now(),
        likes: 0,
        comments: 0,
        sharings: 0,
        disabled: false,
      );

      //Armazeno o 'id' gerado automaticamente pelo 'firestore' para poder salvar a imagem no
      //'firebase storage' com o nome atrelado ao id.
      String idPublication = await _publicationApi.create(publication);

      if (idPublication != '') {
        if (image) {
          await uploadImage(
            pathInput: imagePath!,
            pathExit: 'POST/$idPublication',
            user: user,
            context: context,
          );
        }

        //Caso 'commenting' for diferente de null ele irá criar um criar um 'Comment' que irá
        //adicionar +1 em 'commenting.comments' na publicação que foi comentada e ligar a
        //'Publication' que foi comentada ao comentário.
        if (commenting != null) {
          bool response = await _commentController.create(
            idPublication: commenting.id!,
            idReply: idPublication,
            context: context,
          );
          if (response) {
            commenting.comments++;
            return await _publicationApi.update(commenting);
          } else {
            NotificationSnackbar.showError(
              context,
              'Ocorreu algum erro.',
            );
            return false;
          }
        }
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return false;
    }
  }

  //Atualiza o valor de publication quando houver alguma interação com a mesma, mais
  //especificamente as variáveis 'like', 'commenting' e 'sharing'.
  Future<bool> updatePublication({
    required Publication publication,
    required BuildContext context,
  }) async {
    try {
      return await _publicationApi.update(publication);
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return false;
    }
  }

  //Carrega uma lista paginada de 'Publication' com um limit de 15 'Publication' por página.
  Future<List<Publication>?> searchAll(
    Publication? publication,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }

    try {
      if (publication != null) {
        if (finalList.isTrue) {
          return listPublication;
        }
        listPublication.addAll(await _publicationApi.searchAll(publication));
        if (listPublication.length != listAuxPublication.length) {
          listAuxPublication.clear();
          listAuxPublication.addAll(listPublication);
        } else {
          finalList.value = true;
        }
      } else {
        listPublication.clear();
        listAuxPublication.clear();
        finalList.value = false;
        listPublication.addAll(await _publicationApi.searchAll(null));
      }
      return listPublication;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return null;
    }
  }

  //Pesquisa todas 'Publications' e filtra elas pelo 'text', caso alguma contenha 'text' em
  //'publications.text' é retornada na lista.
  Future<List<Publication>?> searchContainsText(
    String text,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }
    try {
      listPublicationsFound.clear();
      listPublicationsFound
          .addAll(await _publicationApi.searchContainsText(text));
      return listPublicationsFound;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return null;
    }
  }

  //Carrega uma lista paginada de 'Publication' de um usuário específico com um limit de 15
  //'Publication' por página.
  Future<List<Publication>?> searchByUser(
    Publication? publication,
    User user,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }

    try {
      RxList<Publication> listUserPublication = RxList();
      if (publication != null) {
        if (finalListUser[user.id] ?? false) {
          return mapUserPublication[user.id];
        }
        listUserPublication.value = await _publicationApi.searchByUser(
          publication,
          user,
        );
        mapUserPublication[user.id!]!.addAll(listUserPublication);
        if (listUserPublication.length < 15 || listUserPublication.isEmpty) {
          finalListUser[user.id!] = true;
        }
        if (mapUserPublication[user.id!]!.last.id! ==
            mapUserPublication[user.id!]![
                    mapUserPublication[user.id!]!.length - 2]
                .id) {
          mapUserPublication[user.id!]!.removeLast();
        }
      } else {
        finalListUser[user.id!] = false;
        if (mapUserPublication.containsKey(user.id)) {
          mapUserPublication[user.id]!.clear();
        }
        listUserPublication.addAll(
          await _publicationApi.searchByUser(
            null,
            user,
          ),
        );

        mapUserPublication[user.id!] = listUserPublication;
      }
      return mapUserPublication[user.id];
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return null;
    }
  }

  //Carrega uma lista paginada de 'Publication' de um usuário específico sem limite por página.
  Future<List<Publication>> searchByUserNoLimit(
    User user,
    BuildContext context,
  ) async {
    RxList<Publication> listUserPublication = RxList();
    if (!await _internet.checkConnection(context)) {
      return listUserPublication;
    }

    try {
      finalListUser[user.id!] = false;
      listUserPublication.addAll(
        await _publicationApi.searchByUser(
          null,
          user,
        ),
      );

      return listUserPublication;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return listUserPublication;
    }
  }

  //Deleta a 'Publication' e remove ela da lista e/ou do map em que ela possa estar salva.
  Future<bool> delete(Publication publication, BuildContext context) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      _publicationApi.delete(publication.id!);

      if (mapUserPublication.containsKey(publication.user.id)) {
        final userPublications = mapUserPublication[publication.user.id]!;

        userPublications.removeWhere((pub) => pub.id == publication.id);
      }

      listPublication.removeWhere((pub) => pub.id == publication.id);

      NotificationSnackbar.showSuccess(
        context,
        'Publicação excluida com sucesso.',
      );
      return true;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return false;
    }
  }

  //Pesquisa uma 'Publication' pelo 'id'.
  Future<Publication?> searchById(String id, BuildContext context) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }

    Publication? publication;

    try {
      publication = await _publicationApi.searchById(id);

      return publication;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return null;
    }
  }
}
