import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();

  RxBool logando = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
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
                padding: const EdgeInsets.all(10),
                child: Column(
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
                          TextFieldComponent(
                            controller: usuarioController,
                            labelText: "E-mail, telefone ou usuário",
                            width: 100.w,
                            height: 50,
                          ),
                          SizedBox(height: 2.h),
                          TextFieldComponent(
                            controller: senhaController,
                            labelText: "Senha",
                            width: 100.w,
                            height: 50,
                            obscureText: true,
                          ),
                          SizedBox(height: 1.h),
                          Align(
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
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 100.w,
                            height: 50,
                            child: CustomButton(
                              onPressed: () async {
                                logando.value = true;
                                if (usuarioController.text == '' ||
                                    senhaController.text == '') {
                                  NotificationSnackbar.showError(context,
                                      'Email e/ou senha não preenchidos.');
                                  logando.value = false;
                                  return;
                                }

                                await loginController
                                    .login(
                                  usuarioController.text,
                                  senhaController.text,
                                  context,
                                )
                                    .then((value) {
                                  logando.value = false;
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
                            onTap: () => Get.toNamed('/cadastro'),
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
                    Container(
                      width: 85.w,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 234, 67, 53),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomButton(
                        onPressed: () {},
                        color: Colors.white,
                        context: context,
                        text: 'g',
                        fontSize: 20,
                        textColor: const Color.fromARGB(255, 234, 67, 53),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: 85.w,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomButton(
                        onPressed: () {},
                        color: Colors.black,
                        context: context,
                        icon: Icons.apple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => logando.isTrue
                  ? Container(
                      width: 100.w,
                      height: 100.h,
                      color: Colors.black87,
                      child: const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
