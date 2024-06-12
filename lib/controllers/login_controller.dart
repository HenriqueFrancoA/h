// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:h/apis/user_api.dart';
// ignore: library_prefixes
import 'package:h/models/user.dart' as ModelUser;
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

class LoginController extends GetxController {
  final _internet = Internet();

  RxList<ModelUser.User> userLogged = RxList<ModelUser.User>();

  final UserApi _userApi = UserApi();

  late Reference _storageRef;
  RxString coverImage = ''.obs;
  RxString userImage = ''.obs;

  RxBool updatedCoverImage = RxBool(false);
  RxBool updatedUserImage = RxBool(false);
  late BuildContext lateContext;

  //Verifica se as imagens baixadas no celular são a última versão que o usuário salvou
  //como imagem de capa e de usuário, caso não seja ele baixa a ultima imagem e armazena
  //localmente, fazendo com que economize requisições no firestore.
  loadImages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int attCover = prefs.getInt("updatedCover") ?? 0;
      int attUser = prefs.getInt("updatedUser") ?? 0;

      String ref = '';
      String storagePath = '';

      Directory storageDir = await getApplicationDocumentsDirectory();
      storagePath = storageDir.path;

      if (attCover != userLogged.first.updatedCoverImage) {
        coverImage.value = '';

        ref = 'COVER/${userLogged.first.id!}.jpeg';
        _storageRef = FirebaseStorage.instance.ref().child(ref);

        Uint8List? coverData = await _storageRef.getData();

        String coverFileName = 'cover_${DateTime.now()}.jpeg';
        String coverFilePath = '$storagePath/$coverFileName';

        if (await File(coverFilePath).exists()) {
          await File(coverFilePath).delete();
        }

        await File(coverFilePath).writeAsBytes(coverData!);

        coverImage.value = coverFilePath;
        updatedCoverImage.value = !updatedCoverImage.value;
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('cover', coverFilePath);
        });

        await SharedPreferences.getInstance().then((prefs) {
          prefs.setInt('updatedCover', userLogged.first.updatedCoverImage);
        });
      } else {
        coverImage.value = prefs.getString("cover") ?? '';
      }

      if (attUser != userLogged.first.updatedUserImage) {
        userImage.value = '';

        ref = 'USER/${userLogged.first.id!}.jpeg';
        _storageRef = FirebaseStorage.instance.ref().child(ref);

        Uint8List? userData = await _storageRef.getData();

        String userFileName = 'user_${DateTime.now()}.jpeg';
        String userFilePath = '$storagePath/$userFileName';

        if (userData!.isNotEmpty) {
          if (await File(userFilePath).exists()) {
            File(userFilePath).deleteSync(recursive: true);
          }

          await File(userFilePath).writeAsBytes(userData);

          userImage.value = userFilePath;
          updatedUserImage.value = !updatedUserImage.value;
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('user', userFilePath);
          });
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setInt('updatedUser', userLogged.first.updatedUserImage);
          });
        }
      } else {
        userImage.value = prefs.getString("user") ?? '';
      }
    } catch (error) {
      NotificationSnackbar.showError(lateContext, error.toString());
    }
  }

  //Autentica o usuário no 'firebase auth', caso de certo ele procura o usuário no
  //banco de dados pelo UID e salva seus dados para logar automaticamente das próximas vezes.
  Future<bool> login(
    String emailUser,
    String passwordUser,
    BuildContext? context,
  ) async {
    if (context != null && !await _internet.checkConnection(context)) {
      return false;
    }
    try {
      userLogged.clear();
      final usu = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      if (usu.user != null) {
        ModelUser.User user = await _userApi.searchByUId(usu.user!.uid);

        await SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('saveAccess', true);
        });
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('email', emailUser);
        });
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('password', passwordUser);
        });

        userLogged.add(user);
        await loadImages();
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      if (context != null) {
        NotificationSnackbar.showError(
          context,
          e.message ?? 'Ocorreu algum erro.',
        );
      }
      return false;
    }
  }

  //Sai do usuário pelo 'firebase auth' e logo em seguida remove as informações
  //para não se conectar automaticamente nas próximas seções.
  Future<bool> logoff(
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      await FirebaseAuth.instance.signOut();

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('saveAccess', false);
      });
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('email', '');
      });
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('password', '');
      });
      return true;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
        context,
        e.message ?? 'Ocorreu algum erro.',
      );

      return false;
    }
  }

  //Envia um email para o endereço fornecido pelo usuário caso o mesmo exista.
  Future<bool> recoveryPassword(
    String email,
    BuildContext context,
  ) async {
    if (!await _internet.checkConnection(context)) {
      return false;
    }
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);

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
