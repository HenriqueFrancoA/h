import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
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

  RxBool mostrarBarra = RxBool(true);
  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final publicacaoController = Get.put(PublicacaoController());

  final dateFormat = DateFormat('hh:mm - dd/MM/yyyy');

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
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
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
                                        "assets/images/post01.png",
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
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      publicacaoController
                                          .listPublicacao.first.comentarios
                                          .toString(),
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
                                      publicacaoController.listPublicacao.first
                                          .compartilhamentos
                                          .toString(),
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
                                    Text(
                                      publicacaoController
                                          .listPublicacao.first.curtidas
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
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
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.messenger_outline,
                                      size: 20,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.repeat,
                                      size: 20,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      CupertinoIcons.heart_fill,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 0.2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: ListView.separated(
                          itemCount: publicacaoController.listComentario.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CardPostComponent(
                              publicacao: publicacaoController
                                  .listComentario[index].resposta,
                              compartilhado: false,
                            );
                          },
                          separatorBuilder: (context, index) => Container(
                            width: 100.w,
                            height: 0.2,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
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
                BottomBarComponent(
                  mostrarBarra: mostrarBarra,
                  index: 9,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
