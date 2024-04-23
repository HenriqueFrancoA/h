import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final loginController = Get.put(LoginController());
  final publicacaoController = Get.put(PublicacaoController());

  @override
  void initState() {
    super.initState();
    verificarAcesso();
  }

  verificarAcesso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool salvarAcesso = prefs.getBool("salvarAcesso") ?? false;

    String email = prefs.getString("email") ?? '';
    String senha = prefs.getString("senha") ?? '';

    if (salvarAcesso) {
      loginController.login(email, senha, null).then((resposta) async {
        if (resposta) {
          await publicacaoController.carregarPublicacao();

          Timer(
            const Duration(seconds: 2),
            () => Get.offAllNamed('/home'),
          );
        } else {
          Timer(
            const Duration(seconds: 2),
            () => Get.offAllNamed('/login'),
          );
        }
      });
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Get.offAllNamed('/login'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.onBackground,
            ],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
