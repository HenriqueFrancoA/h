import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/utils/get_image.dart';
import 'package:h/utils/horario_converter.dart';
import 'package:h/utils/text_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class PublicarScreen extends StatefulWidget {
  const PublicarScreen({Key? key}) : super(key: key);

  @override
  State<PublicarScreen> createState() => _PublicarScreenState();
}

class _PublicarScreenState extends State<PublicarScreen> {
  Publicacao? comentando = Get.arguments['comentando'];
  Publicacao? compartilhando = Get.arguments['compartilhando'];

  final TextEditingController textoController = TextEditingController();

  final loginController = Get.put(LoginController());
  final publicacaoController = Get.put(PublicacaoController());

  late FocusNode focusNode;

  XFile? image;
  File? file;
  RxBool imagemSelecionada = RxBool(false);

  final GlobalKey _cardPostKey = GlobalKey();
  RxDouble cardPostHeight = 0.0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus(FocusNode());
      if (_cardPostKey.currentContext != null) {
        RenderBox cardPostBox =
            _cardPostKey.currentContext!.findRenderObject() as RenderBox;
        cardPostHeight.value = cardPostBox.size.height;
      }
    });

    focusNode = FocusNode();

    focusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    if (!focusNode.hasFocus) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                comentando != null
                                    ? Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: const Image(
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                AssetImage(
                                                  "assets/images/perfil.png",
                                                ),
                                                width: 88,
                                                height: 137,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Obx(
                                            () => cardPostHeight.value > 0
                                                ? Container(
                                                    height:
                                                        cardPostHeight.value +
                                                            1.h -
                                                            18,
                                                    width: 0.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                ClipRRect(
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
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              comentando != null
                                  ? Column(
                                      children: [
                                        CardPostComponent(
                                          key: _cardPostKey,
                                          publicacao: comentando!,
                                          compartilhado: false,
                                          telaResposta: false,
                                          respondendoDireto: true,
                                          respondendoPublicacao: false,
                                          contador: 0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            width: 100.w - 90,
                                            child: Text(
                                              'Respondendo - @${comentando!.usuario.usuario}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                      ],
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 100.w - 80,
                                      child: TextField(
                                        autofocus: true,
                                        focusNode: focusNode,
                                        controller: textoController,
                                        decoration: InputDecoration(
                                          hintText: 'Escreva sua publicação...',
                                          border: InputBorder.none,
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                        cursorColor: Colors.white,
                                        minLines: 2,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Obx(
                                  () => imagemSelecionada.isTrue
                                      ? Container(
                                          width: 100.w - 100,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            image: DecorationImage(
                                              image: FileImage(
                                                file!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ),
                              compartilhando != null
                                  ? Container(
                                      width: 100.w - 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      margin: const EdgeInsets.all(20),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: const Image(
                                                  width: 30,
                                                  height: 30,
                                                  fit: BoxFit.cover,
                                                  image: ResizeImage(
                                                    AssetImage(
                                                      "assets/images/perfil.png",
                                                    ),
                                                    width: 52,
                                                    height: 90,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              Text(
                                                compartilhando!.usuario.usuario,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                tempoDesdeCriacao(
                                                    compartilhando!
                                                        .dataCriacao),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.h),
                                          SizedBox(
                                            width: 100.w - 80,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  buildTextSpan(
                                                      compartilhando!.texto ??
                                                          '',
                                                      context),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 10.h,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Cancelar',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    CustomButton(
                      onPressed: () {
                        publicacaoController
                            .criar(
                          usuario: loginController.usuarioLogado.first,
                          imagem: imagemSelecionada.value,
                          publicacaoCompartilhada: compartilhando,
                          texto: textoController.text,
                          context: context,
                          comentando: comentando,
                        )
                            .then((resposta) {
                          if (resposta) {
                            Get.back();
                          }
                        });
                      },
                      context: context,
                      text: 'Publicar',
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: const Icon(
                      Icons.attach_file,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () async => await getImage(false, false).then(
                      (imagem) {
                        if (imagem != null) {
                          imagemSelecionada.value = true;
                          file = imagem;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
