import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/controllers/comentario_controller.dart';
import 'package:h/controllers/curtida_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publicacao_controller.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/utils/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PublicacaoScreen extends StatefulWidget {
  const PublicacaoScreen({super.key});

  @override
  State<PublicacaoScreen> createState() => _PublicacaoScreenState();
}

class _PublicacaoScreenState extends State<PublicacaoScreen> {
  final publicacao = Get.arguments['publicacao'] as Publicacao;
  final respondendo = Get.arguments['respondendo'] as Publicacao?;

  final TextEditingController textoController = TextEditingController();

  RxBool mostrarBarra = RxBool(true);
  RxBool tecladoAberto = RxBool(false);
  RxBool curtido = RxBool(false);

  RxDouble cardPostHeight = 0.0.obs;
  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final GlobalKey _cardPostKey = GlobalKey();

  final publicacaoController = Get.put(PublicacaoController());
  final comentarioController = Get.put(ComentarioController());
  final curtidaController = Get.put(CurtidaController());
  final loginController = Get.put(LoginController());

  final dateFormat = DateFormat('hh:mm - dd/MM/yyyy');

  final FocusNode textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    textFieldFocus.addListener(() {
      tecladoAberto.value = textFieldFocus.hasFocus;
    });
    verificarCurtida();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cardPostKey.currentContext != null) {
        RenderBox cardPostBox =
            _cardPostKey.currentContext!.findRenderObject() as RenderBox;
        cardPostHeight.value = cardPostBox.size.height;
      }
    });
  }

  verificarCurtida() async {
    curtido.value = await curtidaController.verificaCurtida(
      usuario: loginController.usuarioLogado.first,
      publicacao: publicacao,
      criarDeletar: false,
      context: context,
    );
  }

  @override
  void dispose() {
    textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
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
                SizedBox(
                  height: 78.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 11.h,
                        ),
                        respondendo != null
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: const Image(
                                            width: 50,
                                            height: 50,
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
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Obx(
                                          () => cardPostHeight.value > 0
                                              ? Container(
                                                  height:
                                                      cardPostHeight.value - 25,
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
                                      ],
                                    ),
                                    const Spacer(),
                                    CardPostComponent(
                                      key: _cardPostKey,
                                      publicacao: respondendo!,
                                      compartilhado: false,
                                      telaResposta: false,
                                      respondendoDireto: false,
                                      respondendoPublicacao: true,
                                      contador: 0,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: const Image(
                                      width: 50,
                                      height: 50,
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
                                  const SizedBox(width: 10),
                                  Text(
                                    publicacao.usuario.usuario,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer(),
                                  CustomButton(
                                    onPressed: () {},
                                    context: context,
                                    text: 'Seguir',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: 11,
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              SizedBox(
                                width: 100.w,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      buildTextSpan(
                                          publicacao.texto ?? '', context),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              publicacao.imagem
                                  ? Column(
                                      children: [
                                        Container(
                                          width: 100.w,
                                          height: 25.h,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
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
                              SizedBox(height: 1.h),
                              publicacao.compartilhamento != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.2,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                width: 78,
                                                height: 137,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          CardPostComponent(
                                            publicacao: publicacao
                                                .compartilhamento!.publicacao,
                                            compartilhado: false,
                                            telaResposta: false,
                                            respondendoDireto: false,
                                            respondendoPublicacao: true,
                                            contador: 1,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 1.h),
                              Text(
                                dateFormat
                                    .format(publicacao.dataCriacao.toDate()),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Center(
                                child: Container(
                                  width: 100.w,
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        publicacao.comentarios.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Comentários',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        publicacao.compartilhamentos.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Compartilhamentos',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => Text(
                                          publicacao.curtidas.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Curtidas',
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
                              SizedBox(height: 1.h),
                              Center(
                                child: Container(
                                  width: 100.w,
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              SizedBox(
                                width: 100.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        textFieldFocus.requestFocus();
                                      },
                                      child: const Icon(
                                        Icons.messenger_outline,
                                        size: 20,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Get.toNamed(
                                          '/publicar',
                                          arguments: {
                                            'comentando': null,
                                            'compartilhando': publicacao,
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.repeat,
                                        size: 20,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        curtidaController
                                            .verificaCurtida(
                                              usuario: loginController
                                                  .usuarioLogado.first,
                                              publicacao: publicacao,
                                              criarDeletar: true,
                                              context: context,
                                            )
                                            .then((value) =>
                                                curtido.value = !curtido.value);
                                      },
                                      child: Obx(
                                        () => Icon(
                                          curtido.isTrue
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                          size: 20,
                                          color: curtido.isTrue
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                            ],
                          ),
                        ),
                        Container(
                          width: 100.w,
                          height: 0.2,
                          color: Colors.grey,
                        ),
                        FutureBuilder(
                          future: comentarioController.buscarPorPublicacao(
                              publicacao, context),
                          builder: (context, snapshot) {
                            return SizedBox(
                              width: 100.w,
                              height: 100.h,
                              child: ListView.separated(
                                itemCount:
                                    comentarioController.listComentarios.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CardPostComponent(
                                    publicacao: comentarioController
                                        .listComentarios[index].resposta,
                                    compartilhado: false,
                                    telaResposta: true,
                                    respondendoDireto: false,
                                    respondendo: publicacao,
                                    respondendoPublicacao: false,
                                    contador: 0,
                                  );
                                },
                                separatorBuilder: (context, index) => Container(
                                  width: 100.w,
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
                            width: 0.2,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Image.asset(
                              "assets/images/logoBranco.png",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 22.h,
                    color: Theme.of(context).colorScheme.onBackground,
                    child: Column(
                      children: [
                        Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.all(10),
                          child: Obx(
                            () => TextField(
                              controller: textoController,
                              focusNode: textFieldFocus,
                              decoration: InputDecoration(
                                hintText: 'Sua resposta...',
                                border: InputBorder.none,
                                hintStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                              style: Theme.of(context).textTheme.labelMedium,
                              cursorColor: Colors.white,
                              minLines: 1,
                              maxLines: tecladoAberto.isTrue ? 4 : 1,
                            ),
                          ),
                        ),
                        Obx(
                          () => tecladoAberto.isTrue
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          textoController.clear();
                                          textFieldFocus.unfocus();
                                          setState(() {});
                                          await Get.toNamed(
                                            '/publicar',
                                            arguments: {
                                              'comentando': publicacao,
                                              'compartilhando': null,
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          CupertinoIcons.fullscreen,
                                        ),
                                      ),
                                      CustomButton(
                                        text: 'Comentar',
                                        onPressed: () {
                                          publicacaoController
                                              .criar(
                                            usuario: loginController
                                                .usuarioLogado.first,
                                            imagem: false,
                                            publicacaoCompartilhada: null,
                                            texto: textoController.text,
                                            context: context,
                                            comentando: publicacao,
                                          )
                                              .then((resposta) {
                                            if (resposta) {}
                                            textoController.clear();
                                            textFieldFocus.unfocus();
                                            setState(() {});
                                          });
                                        },
                                        context: context,
                                        fontSize: 11,
                                      ),
                                    ],
                                  ),
                                )
                              : BottomBarComponent(
                                  mostrarBarra: mostrarBarra,
                                  index: 9,
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
    );
  }
}
