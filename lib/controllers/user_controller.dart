// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h/apis/user_api.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:h/controllers/relation_controller.dart';
import 'package:h/models/publication.dart';
import 'package:h/models/relation.dart';
import 'package:h/utils/image_configs.dart';
//'Model.User' é meu objeto 'User', em alguns arquivos vão estar como 'ModelUser.User'
//pois o firebase também contém uma variável chamada 'User'.
//ignore: library_prefixes
import 'package:h/models/user.dart' as ModelUser;
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

final _relationController = Get.put(RelationController());
final _loginController = Get.put(LoginController());
final _publicationController = Get.put(PublicationController());

class UserController extends GetxController {
  final _internet = Internet();

  RxList<ModelUser.User> listUsers = RxList<ModelUser.User>();
  RxList<ModelUser.User> listUsersFound = RxList<ModelUser.User>();

  RxBool finalList = RxBool(false);

  final UserApi _userApi = UserApi();

  //Cria um novo 'User' no 'firebase auth' e um 'Model.User' no 'firestore database'.
  Future<bool> criar(
    String email,
    String userName,
    String password,
    String? telephone,
    Timestamp dateBirth,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }

    if (!await checkUserName(userName, context)) {
      return false;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ModelUser.User user = ModelUser.User(
        uId: credential.user!.uid,
        email: email,
        userName: userName,
        telephone: telephone,
        dateBirth: dateBirth,
        creationDate: Timestamp.now(),
        followers: 0.obs,
        following: 0.obs,
        userImage: false,
        updatedUserImage: 0,
        coverImage: false,
        updatedCoverImage: 0,
        disabled: false,
      );

      return await _userApi.create(user);
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }

  //Atualiza as informações do 'Model.User'.
  Future<bool> updateUser({
    String? userName,
    String? biography,
    String? location,
    String? telephone,
    Timestamp? dateBirth,
    RxInt? followers,
    RxInt? following,
    File? userImg,
    File? coverImg,
    required ModelUser.User user,
    required BuildContext context,
  }) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    user.biography = biography ?? user.biography;
    user.location = location ?? user.location;
    user.telephone = telephone ?? user.telephone;
    user.dateBirth = dateBirth ?? user.dateBirth;
    user.followers = followers ?? user.followers;
    user.following = following ?? user.following;

    if (coverImg != null) {
      if (!user.coverImage) {
        user.coverImage = true;
      }
    }
    if (userImg != null) {
      if (!user.userImage) {
        user.userImage = true;
      }
    }

    if (userName != null && userName != user.userName) {
      if (await checkUserName(userName, context)) {
        user.userName = userName;
      } else {
        return false;
      }
    }
    try {
      if (coverImg != null) {
        user.updatedCoverImage++;
        await uploadImage(
          pathInput: coverImg.path,
          pathExit: "COVER/${_loginController.userLogged.first.id}",
          user: _loginController.userLogged.first,
          context: context,
        );
      }
      if (userImg != null) {
        user.updatedUserImage++;
        await uploadImage(
          pathInput: userImg.path,
          pathExit: "USER/${_loginController.userLogged.first.id}",
          user: _loginController.userLogged.first,
          context: context,
        );
      }
      bool updatedUser = await _userApi.update(user);

      if (updatedUser) {
        Future.delayed(
          const Duration(seconds: 2),
          () async {
            _publicationController.searchAll(
              null,
              context,
            );

            _publicationController.searchByUser(
              null,
              user,
              context,
            );
          },
        );
        return true;
      } else {
        NotificationSnackbar.showError(context,
            'Ocorreu um erro ao atualizar o usuário. Tente novamente mais tarde.');
        return false;
      }
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return false;
    }
  }

  //Carrega uma lista paginada de 'Model.Users' com um limit de 10 'Model.Users' por página.
  Future<List<ModelUser.User>?> searchAll(
    ModelUser.User? user,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }
    try {
      List<ModelUser.User> listUserAux = RxList();
      if (user != null) {
        if (finalList.isTrue) {
          return listUsers;
        }
        listUserAux.addAll(await _userApi.searchAll(user));
        listUsers.addAll(listUserAux);
        if (listUserAux.length < 15 || listUserAux.isEmpty) {
          finalList.value = true;
        }
      } else {
        listUsers.clear();
        finalList.value = false;
        listUsers.addAll(await _userApi.searchAll(null));
      }
      return listUsers;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return null;
    }
  }

  //Pesquisa todos 'Model.Users' e filtra eles pelo 'userName', caso algum contenha 'userName' em
  //'Model.User.userName' é retornado na lista.
  Future<List<ModelUser.User>?> searchContainsUsername(
    String userName,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }
    try {
      listUsersFound.clear();
      listUsersFound.addAll(await _userApi.searchContainsUsername(userName));
      return listUsersFound;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return null;
    }
  }

  //Faz a verificação se o 'userName' já está sendo utilizado.
  Future<bool> checkUserName(
    String userName,
    BuildContext context,
  ) async {
    ModelUser.User? checkUserAvailable =
        await _userApi.searchByUsername(userName);
    if (checkUserAvailable != null) {
      NotificationSnackbar.showError(
        context,
        'O usuário escolhido já está sendo utilizado por outra pessoa.',
      );
      return false;
    }
    return true;
  }

  //Desativa o 'Model.User' e desfaz suas 'Relations'.
  Future<bool> desactivateUser(
    ModelUser.User user,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      List<Publication>? listPublicationsFound =
          await _publicationController.searchByUserNoLimit(user, context);

      for (Publication publication in listPublicationsFound) {
        await _publicationController.updatePublication(
          publication: publication,
          context: context,
        );
      }

      List<Relation> listRelationsFound =
          await _relationController.searchByRelation(
        user: user,
        following: false,
        context: context,
      );

      listRelationsFound.addAll(await _relationController.searchByRelation(
        user: user,
        following: true,
        context: context,
      ));

      for (Relation relation in listRelationsFound) {
        await _relationController.checkHasRelation(
          following: relation.following,
          user: relation.user,
          createDelete: true,
          context: context,
        );
      }

      await _userApi.update(user);
      return true;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );
      return false;
    }
  }
}
