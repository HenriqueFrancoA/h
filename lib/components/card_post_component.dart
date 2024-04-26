import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/controllers/curtida_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/utils/horario_converter.dart';
import 'package:h/utils/text_utils.dart';
import 'package:sizer/sizer.dart';

class CardPostComponent extends StatefulWidget {
  final Publicacao publicacao;
  final Publicacao? respondendo;
  final bool compartilhado;
  final bool telaResposta;
  final bool respondendoDireto;
  final bool respondendoPublicacao;
  final int contador;
  const CardPostComponent({
    super.key,
    required this.publicacao,
    required this.compartilhado,
    required this.telaResposta,
    required this.respondendoDireto,
    this.respondendo,
    required this.respondendoPublicacao,
    required this.contador,
  });

  @override
  State<CardPostComponent> createState() => _CardPostComponentState();
}

class _CardPostComponentState extends State<CardPostComponent> {
  final curtidaController = Get.put(CurtidaController());
  final loginController = Get.put(LoginController());

  RxBool curtido = RxBool(false);

  late Reference storageRef;
  late RxString imgUsuarioURL = ''.obs;

  @override
  void initState() {
    super.initState();
    verificarCurtida();
    baixarImagens();
  }

  verificarCurtida() async {
    curtido.value = await curtidaController.verificaCurtida(
      usuario: loginController.usuarioLogado.first,
      publicacao: widget.publicacao,
      criarDeletar: false,
      context: context,
    );
  }

  void baixarImagens() {
    String ref = "usuario/${widget.publicacao.usuario.id}.jpeg";
    storageRef = FirebaseStorage.instance.ref().child(ref);
    storageRef.getDownloadURL().then((url) {
      imgUsuarioURL.value = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.respondendoDireto
          ? null
          : Get.toNamed(
              '/publicacao/${widget.publicacao.id}',
              arguments: {
                'publicacao': widget.publicacao,
                'respondendo': widget.respondendo,
              },
            ),
      child: Container(
        padding: widget.respondendoPublicacao
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.respondendoDireto || widget.respondendoPublicacao
                ? Container()
                : Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(
                        '/perfil/${widget.publicacao.usuario.id}',
                        arguments: {
                          'usuario': widget.publicacao.usuario,
                        },
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: widget.publicacao.usuario.imagemUsuario
                            ? widget.publicacao.usuario.usuario ==
                                    loginController.usuarioLogado.first.usuario
                                ? Image(
                                    width: widget.compartilhado ? 30 : 50,
                                    height: widget.compartilhado ? 30 : 50,
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
                                    () => imgUsuarioURL.value.isEmpty
                                        ? SizedBox(
                                            width:
                                                widget.compartilhado ? 30 : 50,
                                            height:
                                                widget.compartilhado ? 30 : 50,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Image(
                                            width:
                                                widget.compartilhado ? 30 : 50,
                                            height:
                                                widget.compartilhado ? 30 : 50,
                                            fit: BoxFit.cover,
                                            image: ResizeImage(
                                              CachedNetworkImageProvider(
                                                imgUsuarioURL.value,
                                              ),
                                              width: 156,
                                              height: 275,
                                            ),
                                          ),
                                  )
                            : Image(
                                width: widget.compartilhado ? 30 : 50,
                                height: widget.compartilhado ? 30 : 50,
                                fit: BoxFit.cover,
                                image: ResizeImage(
                                  const AssetImage(
                                    "assets/images/perfil.png",
                                  ),
                                  width: widget.compartilhado ? 88 : 156,
                                  height: widget.compartilhado ? 137 : 275,
                                ),
                              ),
                      ),
                    ),
                  ),
            widget.respondendoPublicacao
                ? Container()
                : const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: widget.compartilhado ? 100.w - 141 : 100.w - 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.publicacao.usuario.usuario,
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        tempoDesdeCriacao(widget.publicacao.dataCriacao),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
                !widget.telaResposta && widget.publicacao.comentario
                    ? Row(
                        children: [
                          const Icon(
                            Icons.reply,
                            textDirection: TextDirection.rtl,
                            color: Colors.grey,
                            size: 15,
                          ),
                          Text(
                            'Resposta',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  width: widget.compartilhado ? 100.w - 141 : 100.w - 80,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        buildTextSpan(widget.publicacao.texto ?? '', context),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                widget.publicacao.imagem
                    ? Column(
                        children: [
                          Container(
                            width: widget.compartilhado
                                ? 100.w - 141
                                : widget.respondendoDireto
                                    ? 10.h
                                    : 100.w - 80,
                            height: widget.compartilhado
                                ? 16.h
                                : widget.respondendoDireto
                                    ? 10.h
                                    : 20.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/post01b.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      )
                    : Container(),
                widget.publicacao.compartilhamento != null &&
                        widget.contador == 0
                    ? Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                width: 0.5,
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: CardPostComponent(
                              publicacao: widget
                                  .publicacao.compartilhamento!.publicacao,
                              compartilhado: true,
                              telaResposta: widget.telaResposta,
                              respondendoDireto: false,
                              respondendoPublicacao:
                                  widget.respondendoPublicacao,
                              contador: widget.contador + 1,
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      )
                    : Container(),
                widget.compartilhado
                    ? Container()
                    : widget.respondendoDireto
                        ? Container()
                        : SizedBox(
                            width: 100.w - 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await Get.toNamed(
                                          '/publicar',
                                          arguments: {
                                            'comentando': widget.publicacao,
                                            'compartilhando': null,
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.messenger_outline,
                                        size: widget.compartilhado ? 10 : 15,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Obx(
                                      () => Text(
                                        widget.publicacao.comentarios
                                            .toString(),
                                        style: widget.compartilhado
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                            : Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await Get.toNamed(
                                          '/publicar',
                                          arguments: {
                                            'comentando': null,
                                            'compartilhando': widget.publicacao,
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.repeat,
                                        size: widget.compartilhado ? 10 : 15,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Obx(
                                      () => Text(
                                        widget.publicacao.compartilhamentos
                                            .toString(),
                                        style: widget.compartilhado
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                            : Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          curtidaController
                                              .verificaCurtida(
                                                usuario: loginController
                                                    .usuarioLogado.first,
                                                publicacao: widget.publicacao,
                                                criarDeletar: true,
                                                context: context,
                                              )
                                              .then((value) => curtido.value =
                                                  !curtido.value);
                                        },
                                        child: Icon(
                                          curtido.isTrue
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                          size: widget.compartilhado ? 10 : 15,
                                          color: curtido.isTrue
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.publicacao.curtidas.toString(),
                                        style: widget.compartilhado
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                            : Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
