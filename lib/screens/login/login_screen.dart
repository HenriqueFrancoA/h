// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/circular_progress_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/button_components.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = Get.put(LoginController());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  RxBool loading = RxBool(false);
  RxBool validEmail = RxBool(true);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: ContainerBackgroundComponent(
                padding: 10,
                widget: Column(
                  children: [
                    SizedBox(height: 3.h),
                    SizedBox(
                      width: 30,
                      child: Image.asset(
                        "assets/images/logoBranco.png",
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 85.w,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Obx(
                            () => TextFieldComponent(
                              controller: _emailController,
                              hintText: "E-mail",
                              width: 100.w,
                              borderColor:
                                  validEmail.isFalse ? Colors.red : null,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          TextFieldComponent(
                            controller: _passwordController,
                            labelText: "Senha",
                            width: 100.w,
                            obscureText: true,
                          ),
                          SizedBox(height: 1.h),
                          GestureDetector(
                            onTap: () async {
                              validEmail.value = true;
                              if (_emailController.text.isNotEmpty &&
                                  _emailController.text.contains('@')) {
                                await _loginController.recoveryPassword(
                                  _emailController.text,
                                  context,
                                );
                                NotificationSnackbar.showSuccess(
                                  context,
                                  'Verifique o E-mail informado para continuar com a recuperação.',
                                );
                              } else {
                                NotificationSnackbar.showError(
                                  context,
                                  'Insira um E-mail válido para recuperar a senha.',
                                );
                                validEmail.value = false;
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Esqueceu a senha?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey[400],
                                      fontSize: 11,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 100.w,
                            height: 50,
                            child: CustomButtonComponent(
                              onPressed: () async {
                                loading.value = true;
                                validEmail.value = true;
                                if (_emailController.text == '' ||
                                    _passwordController.text == '') {
                                  NotificationSnackbar.showError(
                                    context,
                                    'Email e/ou senha não preenchidos.',
                                  );
                                  loading.value = false;
                                  return;
                                }

                                await _loginController
                                    .login(
                                  _emailController.text,
                                  _passwordController.text,
                                  context,
                                )
                                    .then((value) {
                                  loading.value = false;
                                  if (value) {
                                    Get.offAllNamed("/home");
                                  }
                                });
                              },
                              context: context,
                              text: "Entrar",
                            ),
                          ),
                          SizedBox(height: 2.h),
                          GestureDetector(
                            onTap: () => Get.toNamed('/register'),
                            child: Text(
                              'Criar conta',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey[400],
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                    Container(
                      width: 90.w,
                      height: 0.1,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 4.h),
                    // Container(
                    //   width: 85.w,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: const Color.fromARGB(255, 234, 67, 53),
                    //       width: 2,
                    //     ),
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   child: CustomButtonComponent(
                    //     onPressed: () {},
                    //     color: Colors.white,
                    //     context: context,
                    //     text: 'g',
                    //     fontSize: 20,
                    //     textColor: const Color.fromARGB(255, 234, 67, 53),
                    //   ),
                    // ),
                    // SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
            CircularProgressComponent(loading: loading),
          ],
        ),
      ),
    );
  }
}
