import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/card_mensagem_component.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:sizer/sizer.dart';

class MensagemScreen extends StatefulWidget {
  const MensagemScreen({super.key});

  @override
  State<MensagemScreen> createState() => _MensagemScreenState();
}

class _MensagemScreenState extends State<MensagemScreen> {
  RxBool mostrarBarra = RxBool(true);
  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            scrollPosition = notification.metrics.pixels;
            final scrollDirection = scrollPosition - prevScrollPosition;
            if (scrollDirection > 0) {
              mostrarBarra.value = false;
            } else {
              mostrarBarra.value = true;
            }
            prevScrollPosition = scrollPosition;
            return false;
          },
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
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 10.h,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.offNamed(
                              '/perfil/${loginController.usuarioLogado.first.id}',
                              arguments: {
                                'usuario': null,
                              },
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: loginController
                                      .usuarioLogado.first.imagemUsuario
                                  ? Image(
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      image: ResizeImage(
                                        FileImage(
                                          File(loginController
                                              .imagemUsuario.value),
                                        ),
                                        width: 156,
                                        height: 275,
                                      ),
                                    )
                                  : const Image(
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      image: ResizeImage(
                                        AssetImage(
                                          "assets/images/perfil.png",
                                        ),
                                        width: 130,
                                        height: 240,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Image.asset(
                              "assets/images/logoBranco.png",
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 90.w,
                      height: 50,
                      child: const TextFieldComponent(
                        labelText: 'Usuário',
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      width: 100.w,
                      height: 0.3,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 90.w,
                        height: 70.h,
                        child: ListView.separated(
                          itemCount: 25,
                          itemBuilder: (context, index) {
                            return const CardMensagemComponent();
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BottomBarComponent(
                  mostrarBarra: mostrarBarra,
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
