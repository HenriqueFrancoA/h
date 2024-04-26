import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/usuario_api.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/models/usuario.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final _internetController = Internet();

  RxList<Usuario> usuarioLogado = RxList<Usuario>();

  RxString imagemCapa = ''.obs;
  RxString imagemUsuario = ''.obs;

  RxBool imgCapaAtualizada = RxBool(false);
  RxBool imgUsuarioAtualizada = RxBool(false);

  late Reference _storageRef;

  final UsuarioApi _usuarioApi = UsuarioApi();

  carregarImagens() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int attCapa = prefs.getInt("capaAtualizado") ?? 0;
      int attUsuario = prefs.getInt("usuarioAtualizado") ?? 0;

      String ref = '';
      String storagePath = '';

      Directory storageDir = await getApplicationDocumentsDirectory();
      storagePath = storageDir.path;

      if (attCapa != usuarioLogado.first.imagemCapaAtualizado) {
        imagemCapa.value = '';

        ref = 'capa/${usuarioLogado.first.id!}.jpeg';
        _storageRef = FirebaseStorage.instance.ref().child(ref);

        Uint8List? capaData = await _storageRef.getData();

        String capaFileName = 'capa_${DateTime.now()}.jpeg';
        String capaFilePath = '$storagePath/$capaFileName';

        if (await File(capaFilePath).exists()) {
          await File(capaFilePath).delete();
        }

        await File(capaFilePath).writeAsBytes(capaData!);

        imagemCapa.value = capaFilePath;
        imgCapaAtualizada.value = !imgCapaAtualizada.value;
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('capa', capaFilePath);
        });

        await SharedPreferences.getInstance().then((prefs) {
          prefs.setInt(
              'capaAtualizado', usuarioLogado.first.imagemCapaAtualizado);
        });
      } else {
        imagemCapa.value = prefs.getString("capa") ?? '';
      }

      if (attUsuario != usuarioLogado.first.imagemUsuarioAtualizado) {
        imagemUsuario.value = '';

        ref = 'usuario/${usuarioLogado.first.id!}.jpeg';
        _storageRef = FirebaseStorage.instance.ref().child(ref);

        Uint8List? usuarioData = await _storageRef.getData();

        String usuarioFileName = 'usuario_${DateTime.now()}.jpeg';
        String usuarioFilePath = '$storagePath/$usuarioFileName';

        if (usuarioData!.isNotEmpty) {
          if (await File(usuarioFilePath).exists()) {
            File(usuarioFilePath).deleteSync(recursive: true);
          }

          await File(usuarioFilePath).writeAsBytes(usuarioData);

          imagemUsuario.value = usuarioFilePath;
          imgUsuarioAtualizada.value = !imgUsuarioAtualizada.value;
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('usuario', usuarioFilePath);
          });
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setInt('usuarioAtualizado',
                usuarioLogado.first.imagemUsuarioAtualizado);
          });
        }
      } else {
        imagemUsuario.value = prefs.getString("usuario") ?? '';
      }
    } catch (error) {
      print('Erro ao carregar imagens: $error');
    }
  }

  Future<bool> login(
    String emailUser,
    String senhaUser,
    BuildContext? context,
  ) async {
    if (context != null &&
        !await _internetController.verificaConexao(context)) {
      return false;
    }
    try {
      usuarioLogado.clear();
      final usu = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: senhaUser);
      if (usu.user != null) {
        Usuario user = await _usuarioApi.buscaPorUId(usu.user!.uid);

        await SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('salvarAcesso', true);
        });
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('email', emailUser);
        });
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('senha', senhaUser);
        });

        usuarioLogado.add(user);
        await carregarImagens();
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      if (context != null) {
        // ignore: use_build_context_synchronously
        NotificationSnackbar.showError(context, e.message.toString());
      }
      return false;
    }
  }
}
