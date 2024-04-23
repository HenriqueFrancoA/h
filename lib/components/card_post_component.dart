import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/models/publicacao.dart';
import 'package:h/utils/text_utils.dart';
import 'package:sizer/sizer.dart';

class CardPostComponent extends StatefulWidget {
  final Publicacao publicacao;
  final bool compartilhado;
  const CardPostComponent({
    super.key,
    required this.publicacao,
    required this.compartilhado,
  });

  @override
  State<CardPostComponent> createState() => _CardPostComponentState();
}

class _CardPostComponentState extends State<CardPostComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/publicacao',
        arguments: {
          'publicacao': widget.publicacao,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  width: widget.compartilhado ? 30 : 50,
                  height: widget.compartilhado ? 30 : 50,
                  fit: BoxFit.cover,
                  image: ResizeImage(
                    const AssetImage(
                      "assets/images/post01.png",
                    ),
                    width: widget.compartilhado ? 88 : 156,
                    height: widget.compartilhado ? 137 : 275,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                        '5 min',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
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
                            width:
                                widget.compartilhado ? 100.w - 141 : 100.w - 80,
                            height: widget.compartilhado ? 16.h : 20.h,
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
                widget.publicacao.compartilhamento != null
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
                              publicacao: widget.publicacao.compartilhamento!,
                              compartilhado: true,
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      )
                    : Container(),
                widget.compartilhado
                    ? Container()
                    : SizedBox(
                        width: 100.w - 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.messenger_outline,
                                    size: widget.compartilhado ? 15 : 20,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.publicacao.comentarios.toString(),
                                  style: widget.compartilhado
                                      ? Theme.of(context).textTheme.labelSmall
                                      : Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.repeat,
                                    size: widget.compartilhado ? 15 : 20,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.publicacao.compartilhamentos
                                      .toString(),
                                  style: widget.compartilhado
                                      ? Theme.of(context).textTheme.labelSmall
                                      : Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    CupertinoIcons.heart_fill,
                                    size: widget.compartilhado ? 15 : 20,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.publicacao.curtidas.toString(),
                                  style: widget.compartilhado
                                      ? Theme.of(context).textTheme.labelSmall
                                      : Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
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
