// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h/apis/relation_api.dart';
import 'package:h/controllers/user_controller.dart';
import 'package:h/models/dto/relation_dto.dart';
import 'package:h/models/relation.dart';
import 'package:h/models/user.dart';
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

final _userController = Get.put(UserController());

class RelationController extends GetxController {
  final _internet = Internet();

  final RelationApi _relationApi = RelationApi();

  RxList<Relation> listRelation = RxList<Relation>();

  //Verifica se existe relação de 'user'/'following' entre dois 'Users'.
  //Caso 'createDelete' seja verdadeiro que o 'userLogged' clicou para seguir
  //e a função irá verificar se já existe essa 'Relation' entre ambos 'Users',
  //caso exista irá ser deletado e caso não irá ser criado.
  Future<bool> checkHasRelation({
    required User following,
    required User user,
    required bool createDelete,
    required BuildContext context,
  }) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      var db = FirebaseFirestore.instance;

      Relation relation = Relation(
        user: user,
        following: following,
      );

      Relation? relationFound = await _relationApi.checkRelation(relation);

      if (!createDelete) {
        if (relationFound != null) {
          return true;
        } else {
          return false;
        }
      }

      if (relationFound != null) {
        await _relationApi.delete(relationFound.id!);
        user.following--;
        await _userController.updateUser(
          user: user,
          context: context,
        );
        following.followers--;
        await _userController.updateUser(
          user: following,
          context: context,
        );
        return true;
      } else {
        RelationDto relationDto = RelationDto(
          user: db.doc("USER/${user.id}"),
          following: db.doc("USER/${following.id}"),
        );
        bool response = await _relationApi.create(relationDto);

        if (response) {
          user.following++;
          await _userController.updateUser(
            user: user,
            context: context,
          );
          following.followers++;
          await _userController.updateUser(
            user: following,
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

  //Pesquisa todas as relações baseadas no 'user' ou no 'following'.
  Future<List<Relation>> searchByRelation({
    required User user,
    required bool following,
    required BuildContext context,
  }) async {
    listRelation.clear();
    if (!await _internet.checkConnection(context)) {
      return listRelation;
    }
    try {
      if (following) {
        listRelation.addAll(await _relationApi.searchByFollowing(user));
      } else {
        listRelation.addAll(await _relationApi.searchByFollower(user));
      }

      return listRelation;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return listRelation;
    }
  }
}
