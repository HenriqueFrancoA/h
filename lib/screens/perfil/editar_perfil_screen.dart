import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/controllers/usuario_controller.dart';
import 'package:h/utils/get_image.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/login_controller.dart';

// ignore: must_be_immutable
class EditarPerfilScreen extends StatefulWidget {
  Function onTap;
  EditarPerfilScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final usuarioController = TextEditingController();
  final bioController = TextEditingController();
  final localizacaoController = TextEditingController();

  final loginController = Get.put(LoginController());
  final userController = Get.put(UsuarioController());

  File? imgCapa;
  File? imgUsuario;

  RxBool imagemCapaSelecionada = RxBool(false);
  RxBool imagemUsuarioSelecionada = RxBool(false);
  RxBool salvando = RxBool(false);

  @override
  void initState() {
    super.initState();

    if (loginController.usuarioLogado.isNotEmpty) {
      usuarioController.text = loginController.usuarioLogado.first.usuario;
      bioController.text = loginController.usuarioLogado.first.biografia ?? '';
      localizacaoController.text =
          loginController.usuarioLogado.first.localizacao ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          color: Colors.black87,
        ),
        Dismissible(
          key: const Key(''),
          onDismissed: (direction) => widget.onTap(),
          direction: DismissDirection.down,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                width: 100.w,
                height: 90.h,
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => widget.onTap(),
                            child: SizedBox(
                              width: 20.w,
                              child: Text(
                                'Cancelar',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          Text(
                            'Editar Perfil',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          GestureDetector(
                            onTap: () {
                              salvando.value = true;

                              userController
                                  .atualizar(
                                usuario: usuarioController.text,
                                biografia: bioController.text,
                                localizacao: localizacaoController.text,
                                imgUsuario: imgUsuario,
                                imgCapa: imgCapa,
                                user: loginController.usuarioLogado.first,
                                context: context,
                              )
                                  .then((value) {
                                Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  await loginController.carregarImagens();
                                  salvando.value = false;
                                  widget.onTap();
                                  Get.offAllNamed(
                                    '/perfil/${loginController.usuarioLogado.first.id}',
                                    arguments: {
                                      'usuario': null,
                                    },
                                  );
                                });
                              });
                            },
                            child: SizedBox(
                              width: 20.w,
                              child: Text(
                                textAlign: TextAlign.end,
                                'Salvar',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      height: 25.h,
                      child: Stack(
                        children: [
                          Obx(
                            () => imagemCapaSelecionada.isTrue
                                ? Container(
                                    width: 100.h,
                                    height: 18.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(
                                          imgCapa!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : loginController.usuarioLogado.first.imagemCapa
                                    ? Obx(
                                        () => Container(
                                          color: Colors.transparent,
                                          child: Image(
                                            image: ResizeImage(
                                              FileImage(
                                                File(loginController
                                                    .imagemCapa.value),
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
                          ),
                          GestureDetector(
                            onTap: () async {
                              imagemCapaSelecionada.value = false;
                              await getImage(true, true).then(
                                (imagem) {
                                  if (imagem != null) {
                                    imagemCapaSelecionada.value = true;
                                    imgCapa = imagem;
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: 100.w,
                              height: 18.h,
                              color: Colors.black54,
                              child: const Center(
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 30,
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
                                color: Theme.of(context).colorScheme.background,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: GestureDetector(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Stack(
                                    children: [
                                      Obx(
                                        () => imagemUsuarioSelecionada.isTrue
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                      imgUsuario!,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : loginController.usuarioLogado
                                                    .first.imagemUsuario
                                                ? Image(
                                                    fit: BoxFit.cover,
                                                    image: ResizeImage(
                                                      FileImage(
                                                        File(loginController
                                                            .imagemUsuario
                                                            .value),
                                                      ),
                                                      width: 156,
                                                      height: 275,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: 13.h,
                                                    height: 13.h,
                                                    child: const Image(
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
                                      GestureDetector(
                                        onTap: () async {
                                          imagemUsuarioSelecionada.value =
                                              false;
                                          await getImage(true, false).then(
                                            (imagem) {
                                              if (imagem != null) {
                                                imagemUsuarioSelecionada.value =
                                                    true;
                                                imgUsuario = imagem;
                                              }
                                            },
                                          );
                                        },
                                        child: Container(
                                          color: Colors.black54,
                                          child: const Center(
                                            child: Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: 100.w,
                      height: 0.1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35.w,
                            child: Text(
                              'Nome',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(
                            width: 65.w - 20,
                            child: TextFieldComponent(
                              controller: usuarioController,
                              labelText: '',
                              color: Colors.transparent,
                              maxLength: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 0.1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 35.w,
                                height: 50,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Bio',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 65.w - 20,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: bioController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                              style: Theme.of(context).textTheme.labelMedium,
                              cursorColor: Colors.white,
                              minLines: 4,
                              maxLines: 4,
                              maxLength: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 0.1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35.w,
                            child: Text(
                              'Localização',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(
                            width: 65.w - 20,
                            child: TextFieldComponent(
                              controller: localizacaoController,
                              labelText: '',
                              color: Colors.transparent,
                              maxLength: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 0.1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => salvando.isTrue
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
    );
  }
}
