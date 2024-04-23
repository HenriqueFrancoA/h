import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:h/screens/perfil/editar_perfil_screen.dart';
import 'package:h/utils/text_utils.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  RxBool mostrarBarra = RxBool(true);
  RxBool scrollable = RxBool(false);
  RxBool editarPerfil = RxBool(false);

  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  ScrollController scrollController = ScrollController();

  final loginController = Get.put(LoginController());
  final publicacaoController = Get.put(PublicacaoController());

  final dateFormat = DateFormat('dd MMMM yyyy');

  GlobalKey lastProfileWidgetKey = GlobalKey();

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    final isLastWidgetVisible = scrollController.position.pixels <= 25.h;

    scrollable.value = !isLastWidgetVisible;

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      mostrarBarra.value = false;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      mostrarBarra.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Container(
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
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 25.h,
                          child: Stack(
                            children: [
                              loginController.usuarioLogado.first.imagemCapa
                                  ? Obx(
                                      () => Container(
                                        color: Colors.transparent,
                                        child: Image(
                                          image: ResizeImage(
                                            FileImage(
                                              File(
                                                loginController
                                                    .imagemCapa.value,
                                              ),
                                            ),
                                            width: 486,
                                            height: 864,
                                          ),
                                          width: 100.w,
                                          height: 18.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 100.w,
                                      height: 18.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/capa.jpg",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => Get.offNamed('/home'),
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 13.h,
                                  height: 13.h,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: loginController
                                              .usuarioLogado.first.imagemUsuario
                                          ? Image(
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
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                AssetImage(
                                                  "assets/images/post01.png",
                                                ),
                                                width: 156,
                                                height: 275,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          loginController
                                              .usuarioLogado.first.usuario,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        SizedBox(
                                          height: 35,
                                          child: CustomButton(
                                            onPressed: () =>
                                                editarPerfil.value = true,
                                            context: context,
                                            text: 'Editar Perfil',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              loginController.usuarioLogado.first.biografia !=
                                          null &&
                                      loginController.usuarioLogado.first
                                          .biografia!.isNotEmpty
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                buildTextSpan(
                                                  loginController.usuarioLogado
                                                          .first.biografia ??
                                                      '',
                                                  context,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                      ],
                                    )
                                  : Container(),
                              loginController.usuarioLogado.first.localizacao !=
                                          null &&
                                      loginController.usuarioLogado.first
                                          .localizacao!.isNotEmpty
                                  ? Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.map_pin,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          loginController
                                              .usuarioLogado.first.localizacao!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              Text(
                                'criado em ${dateFormat.format(loginController.usuarioLogado.first.dataCriacao.toDate())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Text(
                                    loginController
                                        .usuarioLogado.first.seguidores
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Seguidores',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    loginController.usuarioLogado.first.seguindo
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Seguindo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 100.w,
                      height: 0.1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 100.w,
                      child: ListView.separated(
                        itemCount:
                            publicacaoController.listPublicacao.length + 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          index = index - 1;
                          return index < 0
                              ? const SizedBox()
                              : CardPostComponent(
                                  publicacao: publicacaoController
                                      .listPublicacao[index],
                                  compartilhado: false,
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
                      // ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => AnimatedOpacity(
                  opacity: scrollable.isFalse ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: 100.w,
                    height: 7.h,
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/capa.jpg",
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 10.h,
                        ),
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              width: 100.w,
                              height: 10.h,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => Get.offNamed('/home'),
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  loginController.usuarioLogado.first.usuario,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BottomBarComponent(
                mostrarBarra: mostrarBarra,
                index: 9,
              ),
              Obx(
                () => editarPerfil.isFalse
                    ? Container()
                    : EditarPerfilScreen(
                        onTap: () => editarPerfil.value = false,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
