// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/usuario_api.dart';
import 'package:h/controllers/internet_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/models/usuario.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:intl/intl.dart';

class UsuarioController extends GetxController {
  final internetController = Get.put(InternetController());
  final loginController = Get.put(LoginController());

  final dateFormat = DateFormat('dd MMMM yyyy');

  Future<bool> upload(
    String path,
    bool capa,
    BuildContext context,
  ) async {
    File file = File(path);
    String ref = '';

    try {
      if (capa) {
        ref = 'capa/${loginController.usuarioLogado.first.id}.jpeg';
      } else {
        ref = 'usuario/${loginController.usuarioLogado.first.id}.jpeg';
      }
      final storageRef = FirebaseStorage.instance.ref();
      storageRef.child(ref).delete();
      storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=600",
              contentType: "image/jpeg",
              customMetadata: {
                loginController.usuarioLogado.first.usuario:
                    dateFormat.format(DateTime.now()),
              },
            ),
          );
      return true;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(context, e.message ?? '');
      return false;
    }
  }

  Future<bool> criarUsuario(
    String email,
    String usuario,
    String senha,
    String? telefone,
    Timestamp dataNascimento,
    BuildContext context,
  ) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }

    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    Usuario user = Usuario(
      uId: credential.user!.uid,
      email: email,
      usuario: usuario,
      senha: senha,
      telefone: telefone,
      dataNascimento: dataNascimento,
      dataCriacao: Timestamp.now(),
      seguidores: 0,
      seguindo: 0,
      imagemUsuario: false,
      imagemUsuarioAtualizado: 0,
      imagemCapa: false,
      imagemCapaAtualizado: 0,
    );

    return await UsuarioApi.criarUsuario(user);
  }

  Future<bool> atualizarUsuario({
    String? usuario,
    String? biografia,
    String? localizacao,
    String? telefone,
    Timestamp? dataNascimento,
    int? seguidores,
    int? seguindo,
    File? imgUsuario,
    File? imgCapa,
    required Usuario user,
    required BuildContext context,
  }) async {
    if (!await internetController.verificaConexao(context)) {
      return false;
    }
    user.biografia = biografia ?? user.biografia;
    user.localizacao = localizacao ?? user.localizacao;
    user.telefone = telefone ?? user.telefone;
    user.dataNascimento = dataNascimento ?? user.dataNascimento;
    user.seguidores = seguidores ?? user.seguidores;
    user.seguindo = seguindo ?? user.seguindo;

    if (imgCapa != null) {
      if (!user.imagemCapa) {
        user.imagemCapa = true;
      }
    }
    if (imgUsuario != null) {
      if (!user.imagemUsuario) {
        user.imagemUsuario = true;
      }
    }

    if (usuario != null && usuario != user.usuario) {
      Usuario? verificaUsuarioDisponivel =
          await UsuarioApi.buscaPorUsuario(usuario);

      if (verificaUsuarioDisponivel != null) {
        NotificationSnackbar.showError(context,
            'Não foi possível trocar o usuário, usuário já está sendo utilizado por outra pessoa.');
        return false;
      } else {
        usuario = user.usuario;
      }
    }
    try {
      if (imgCapa != null) {
        user.imagemCapaAtualizado++;
        await upload(imgCapa.path, true, context);
      }
      if (imgUsuario != null) {
        user.imagemUsuarioAtualizado++;
        await upload(imgUsuario.path, false, context);
      }
      bool usuarioAtualizado = await UsuarioApi.atualizarUsuario(user);

      if (usuarioAtualizado) {
        NotificationSnackbar.showSuccess(
            context, 'Perfil atualizado com sucesso!');
        return true;
      } else {
        NotificationSnackbar.showError(context,
            'Ocorreu um erro ao atualizar o usuário. Tente novamente mais tarde.');
        return false;
      }
    } catch (e) {
      NotificationSnackbar.showError(context,
          'Ocorreu um erro ao atualizar o usuário. Tente novamente mais tarde.');
      return false;
    }
  }
}
