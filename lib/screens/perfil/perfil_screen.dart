import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:h/controllers/relacao_controller.dart';
import 'package:h/models/usuario.dart';
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
  final usuario = Get.arguments['usuario'] as Usuario?;

  RxBool mostrarBarra = RxBool(true);
  RxBool scrollable = RxBool(false);
  RxBool editarPerfil = RxBool(false);
  RxBool seguindo = RxBool(false);

  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  ScrollController scrollController = ScrollController();

  final publicacaoController = Get.put(PublicacaoController());
  final relacaoController = Get.put(RelacaoController());
  final loginController = Get.put(LoginController());

  final dateFormat = DateFormat('dd MMMM yyyy');

  GlobalKey lastProfileWidgetKey = GlobalKey();
  Usuario? usuarioPerfil;

  late Reference storageRef;

  late RxString imgCapaURL = ''.obs;
  late RxString imgUsuarioURL = ''.obs;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();

    if (usuario != null) {
      usuarioPerfil = Usuario(
        id: usuario!.id,
        uId: usuario!.uId,
        email: usuario!.email,
        usuario: usuario!.usuario,
        senha: usuario!.senha,
        biografia: usuario!.biografia,
        localizacao: usuario!.localizacao,
        telefone: usuario!.telefone,
        dataNascimento: usuario!.dataNascimento,
        dataCriacao: usuario!.dataCriacao,
        seguidores: usuario!.seguidores,
        seguindo: usuario!.seguindo,
        imagemUsuario: usuario!.imagemUsuario,
        imagemUsuarioAtualizado: usuario!.imagemUsuarioAtualizado,
        imagemCapa: usuario!.imagemCapa,
        imagemCapaAtualizado: usuario!.imagemCapaAtualizado,
      );
      baixarImagens();
      verificarSeguir();
    } else {
      usuarioPerfil = Usuario(
        id: loginController.usuarioLogado.first.id,
        uId: loginController.usuarioLogado.first.uId,
        email: loginController.usuarioLogado.first.email,
        usuario: loginController.usuarioLogado.first.usuario,
        senha: loginController.usuarioLogado.first.senha,
        biografia: loginController.usuarioLogado.first.biografia,
        localizacao: loginController.usuarioLogado.first.localizacao,
        telefone: loginController.usuarioLogado.first.telefone,
        dataNascimento: loginController.usuarioLogado.first.dataNascimento,
        dataCriacao: loginController.usuarioLogado.first.dataCriacao,
        seguidores: loginController.usuarioLogado.first.seguidores,
        seguindo: loginController.usuarioLogado.first.seguindo,
        imagemUsuario: loginController.usuarioLogado.first.imagemUsuario,
        imagemUsuarioAtualizado:
            loginController.usuarioLogado.first.imagemUsuarioAtualizado,
        imagemCapa: loginController.usuarioLogado.first.imagemCapa,
        imagemCapaAtualizado:
            loginController.usuarioLogado.first.imagemCapaAtualizado,
      );
    }
  }

  verificarSeguir() async {
    seguindo.value = await relacaoController.verificaSeguir(
      seguindo: usuario!,
      usuario: loginController.usuarioLogado.first,
      criarDeletar: false,
      context: context,
    );
  }

  void baixarImagens() {
    String ref = "capa/${usuario!.id}.jpeg";
    storageRef = FirebaseStorage.instance.ref().child(ref);
    storageRef.getDownloadURL().then((url) {
      imgCapaURL.value = url;
    });
    ref = "usuario/${usuario!.id}.jpeg";
    storageRef = FirebaseStorage.instance.ref().child(ref);
    storageRef.getDownloadURL().then((url) {
      imgUsuarioURL.value = url;
    });
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
      canPop: false,
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
                              usuarioPerfil!.imagemCapa
                                  ? Obx(
                                      () => Container(
                                          color: Colors.transparent,
                                          child: usuario == null ||
                                                  (usuario != null &&
                                                      usuario!.usuario ==
                                                          loginController
                                                              .usuarioLogado
                                                              .first
                                                              .usuario)
                                              ? Image(
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
                                                )
                                              : imgCapaURL.value.isEmpty
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : Image(
                                                      image: ResizeImage(
                                                        CachedNetworkImageProvider(
                                                            imgCapaURL.value),
                                                        width: 486,
                                                        height: 864,
                                                      ),
                                                      width: 100.w,
                                                      height: 18.h,
                                                      fit: BoxFit.cover,
                                                    )),
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
                                      child: usuarioPerfil!.imagemUsuario
                                          ? usuario == null ||
                                                  (usuario != null &&
                                                      usuario!.usuario ==
                                                          loginController
                                                              .usuarioLogado
                                                              .first
                                                              .usuario)
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
                                              : Obx(
                                                  () => imgUsuarioURL
                                                          .value.isEmpty
                                                      ? const CircularProgressIndicator(
                                                          color: Colors.white,
                                                        )
                                                      : Image(
                                                          fit: BoxFit.cover,
                                                          image: ResizeImage(
                                                            CachedNetworkImageProvider(
                                                                imgUsuarioURL
                                                                    .value),
                                                            width: 156,
                                                            height: 275,
                                                          ),
                                                        ),
                                                )
                                          : const Image(
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                AssetImage(
                                                  "assets/images/perfil.png",
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
                                          usuarioPerfil!.usuario,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        usuario == null ||
                                                (usuario != null &&
                                                    usuario!.usuario ==
                                                        loginController
                                                            .usuarioLogado
                                                            .first
                                                            .usuario)
                                            ? CustomButton(
                                                onPressed: () =>
                                                    editarPerfil.value = true,
                                                context: context,
                                                text: 'Editar Perfil',
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                              )
                                            : Obx(
                                                () => CustomButton(
                                                  onPressed: () async {
                                                    bool retorno =
                                                        await relacaoController
                                                            .verificaSeguir(
                                                      seguindo: usuario!,
                                                      usuario: loginController
                                                          .usuarioLogado.first,
                                                      criarDeletar: true,
                                                      context: context,
                                                    );
                                                    if (retorno) {
                                                      seguindo.value =
                                                          !seguindo.value;
                                                    }
                                                  },
                                                  context: context,
                                                  text: seguindo.value
                                                      ? 'Seguindo'
                                                      : 'Seguir',
                                                  fontSize: 11,
                                                  color: seguindo.value
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                      : Theme.of(context)
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
                              usuarioPerfil!.biografia != null &&
                                      usuarioPerfil!.biografia!.isNotEmpty
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                buildTextSpan(
                                                  usuarioPerfil!.biografia!,
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
                              usuarioPerfil!.localizacao != null &&
                                      usuarioPerfil!.localizacao!.isNotEmpty
                                  ? Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.location_solid,
                                          size: 13,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          usuarioPerfil!.localizacao!,
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
                                'criado em ${dateFormat.format(usuarioPerfil!.dataCriacao.toDate())}',
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
                                  Obx(
                                    () => Text(
                                      usuarioPerfil!.seguidores.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
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
                                  Obx(
                                    () => Text(
                                      usuarioPerfil!.seguindo.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
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
                    FutureBuilder(
                        future: publicacaoController.buscarPorUsuario(
                            usuarioPerfil!, 1, context),
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: 100.w,
                            child: ListView.separated(
                              itemCount: snapshot.data != null
                                  ? snapshot.data!.length + 1
                                  : 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                index = index - 1;
                                return index < 0
                                    ? const SizedBox()
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
                            // ),
                          );
                        }),
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
                                  usuarioPerfil!.usuario,
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
