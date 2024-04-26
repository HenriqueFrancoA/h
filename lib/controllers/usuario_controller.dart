// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/apis/usuario_api.dart';
import 'package:h/utils/internet_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/models/usuario.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:intl/intl.dart';

class UsuarioController extends GetxController {
  final internetController = Internet();
  final loginController = Get.put(LoginController());

  final dateFormat = DateFormat('dd MMMM yyyy');

  final UsuarioApi usuarioApi = UsuarioApi();

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
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return false;
    }
  }

  Future<bool> criar(
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

    if (!await verificaUsuario(usuario, context)) {
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
      seguidores: 0.obs,
      seguindo: 0.obs,
      imagemUsuario: false,
      imagemUsuarioAtualizado: 0,
      imagemCapa: false,
      imagemCapaAtualizado: 0,
    );

    return await usuarioApi.criar(user);
  }

  Future<bool> atualizar({
    String? usuario,
    String? biografia,
    String? localizacao,
    String? telefone,
    Timestamp? dataNascimento,
    RxInt? seguidores,
    RxInt? seguindo,
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
      if (await verificaUsuario(usuario, context)) {
        usuario = user.usuario;
      } else {
        return false;
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
      bool usuarioAtualizado = await usuarioApi.atualizar(user);

      if (usuarioAtualizado) {
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

  Future<bool> verificaUsuario(
    String usuario,
    BuildContext context,
  ) async {
    Usuario? verificaUsuarioDisponivel =
        await UsuarioApi.buscaPorUsuario(usuario);
    if (verificaUsuarioDisponivel != null) {
      NotificationSnackbar.showError(context,
          'O usuário escolhido já está sendo utilizado por outra pessoa.');
      return false;
    }
    return true;
  }
}
