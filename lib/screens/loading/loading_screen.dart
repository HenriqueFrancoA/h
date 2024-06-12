// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/container_background_component.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:h/controllers/login_controller.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  checkAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool saveAccess = prefs.getBool("saveAccess") ?? false;

    String email = prefs.getString("email") ?? '';
    String password = prefs.getString("password") ?? '';

    if (saveAccess) {
      _loginController
          .login(
        email,
        password,
        context,
      )
          .then((response) {
        if (response) {
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
    return const PopScope(
      canPop: false,
      child: ContainerBackgroundComponent(
        widget: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
