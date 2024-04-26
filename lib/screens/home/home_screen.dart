import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxBool mostrarBarra = RxBool(true);
  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final loginController = Get.put(LoginController());
  final publicacaoController = Get.put(PublicacaoController());

  int pagina = 1;

  @override
  void initState() {
    super.initState();
  }

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
                FutureBuilder(
                    future: publicacaoController.buscarTodas(null, context),
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: ListView.separated(
                          itemCount: snapshot.data != null
                              ? snapshot.data!.length + 1
                              : 0,
                          itemBuilder: (context, index) {
                            index = index - 1;

                            if (index == snapshot.data!.length - 1) {
                              pagina++;

                              return SizedBox(
                                height: 50.h,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }

                            return index < 0
                                ? SizedBox(
                                    height: 10.h,
                                  )
                                : CardPostComponent(
                                    publicacao: snapshot.data![index],
                                    compartilhado: false,
                                    telaResposta: false,
                                    respondendoDireto: false,
                                    respondendoPublicacao: false,
                                    contador: 0,
                                  );
                          },
                          separatorBuilder: (context, index) => index == 0
                              ? Container()
                              : Container(
                                  width: 100.w,
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                        ),
                      );
                    }),
                Obx(
                  () => AnimatedOpacity(
                    opacity: mostrarBarra.isTrue ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 100.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
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
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              '/publicar',
                              arguments: {
                                'comentando': null,
                                'compartilhando': null,
                              },
                            ),
                            child: const Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomBarComponent(
                  mostrarBarra: mostrarBarra,
                  index: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
