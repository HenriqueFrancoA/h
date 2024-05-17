import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/user_default_image_component.dart';
import 'package:h/controllers/like_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/models/publication.dart';
import 'package:h/utils/converter_time.dart';
import 'package:h/utils/image_configs.dart';
import 'package:h/utils/text_utils.dart';

class CardPostComponent extends StatefulWidget {
  final Publication publication;
  final Publication? reply;
  final bool sharing;
  final bool replyScreen;
  final bool replyDirectly;
  final bool replyPublication;
  final int contador;
  const CardPostComponent({
    super.key,
    required this.publication,
    required this.sharing,
    required this.replyScreen,
    required this.replyDirectly,
    this.reply,
    required this.replyPublication,
    required this.contador,
  });

  @override
  State<CardPostComponent> createState() => _CardPostComponentState();
}

class _CardPostComponentState extends State<CardPostComponent> {
  final _likeController = Get.put(LikeController());
  final _publicationController = Get.put(PublicationController());
  final _loginController = Get.put(LoginController());

  RxBool like = RxBool(false);

  late RxString userImgUrl = ''.obs;
  late RxString postImgUrl = ''.obs;

  @override
  void initState() {
    super.initState();
    if (!widget.replyPublication &&
        !widget.replyDirectly &&
        !widget.replyScreen &&
        !widget.sharing) {
      checkLike();
    }
    getUrls();
  }

  checkLike() async {
    like.value = await _likeController.checkLikes(
      user: _loginController.userLogged.first,
      publication: widget.publication,
      createDelete: false,
      context: context,
    );
  }

  void getUrls() async {
    if (widget.publication.user.userImage) {
      userImgUrl.value =
          await downloadImages("USER/${widget.publication.user.id}.jpeg");
    }
    if (widget.publication.image) {
      postImgUrl.value =
          await downloadImages("POST/${widget.publication.id}.jpeg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.replyDirectly
          ? null
          : () async {
              await _publicationController
                  .searchById(widget.publication.id!, context)
                  .then(
                (publi) {
                  if (publi != null) {
                    Get.toNamed(
                      '/publication/${widget.publication.id}',
                      arguments: {
                        'publication': publi,
                        'reply': widget.reply,
                      },
                    );
                  }
                },
              );
            },
      child: Container(
        padding: widget.replyPublication
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.replyDirectly || widget.replyPublication
                ? Container()
                : Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(
                        '/profile/${widget.publication.user.id}',
                        arguments: {
                          'user': widget.publication.user,
                        },
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: widget.publication.user.userImage
                            ? widget.publication.user.userName ==
                                    _loginController.userLogged.first.userName
                                ? Image(
                                    width: widget.sharing ? 30 : 50,
                                    height: widget.sharing ? 30 : 50,
                                    fit: BoxFit.cover,
                                    image: ResizeImage(
                                      FileImage(
                                        File(_loginController.userImage.value),
                                      ),
                                      width: 156,
                                      height: 275,
                                    ),
                                  )
                                : Obx(
                                    () => userImgUrl.value.isEmpty
                                        ? Container(
                                            width: widget.sharing ? 30 : 50,
                                            height: widget.sharing ? 30 : 50,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          )
                                        : Image(
                                            width: widget.sharing ? 30 : 50,
                                            height: widget.sharing ? 30 : 50,
                                            fit: BoxFit.cover,
                                            image: ResizeImage(
                                              CachedNetworkImageProvider(
                                                userImgUrl.value,
                                              ),
                                              width: 156,
                                              height: 275,
                                            ),
                                          ),
                                  )
                            : UserDefaultImageComponent(
                                width: widget.sharing ? 30 : 50,
                                height: widget.sharing ? 30 : 50,
                                widthQuality: widget.sharing ? 88 : 156,
                                heightQuality: widget.sharing ? 137 : 275,
                              ),
                      ),
                    ),
                  ),
            widget.replyPublication ? Container() : const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: widget.sharing ? 100.w - 141 : 100.w - 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.publication.user.userName,
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        timeSinceCreation(widget.publication.creationDate),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
                widget.publication.disabled
                    ? Column(
                        children: [
                          SizedBox(height: 1.h),
                          Center(
                            child: SizedBox(
                              width: widget.sharing ? 100.w - 141 : 100.w - 80,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    buildTextSpan(
                                      'Essa publicação foi removida pelo o usuário.',
                                      context,
                                      Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.replyScreen && widget.publication.comment
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
                            width: widget.sharing ? 100.w - 141 : 100.w - 80,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  buildTextSpan(
                                    widget.publication.text ?? '',
                                    context,
                                    null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          widget.publication.image
                              ? Obx(
                                  () => postImgUrl.value.isEmpty
                                      ? Container(
                                          width: widget.sharing
                                              ? 100.w - 141
                                              : widget.replyDirectly
                                                  ? 10.h
                                                  : 100.w - 80,
                                          height: widget.sharing
                                              ? 16.h
                                              : widget.replyDirectly
                                                  ? 10.h
                                                  : 20.h,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            width: widget.sharing
                                                ? 100.w - 141
                                                : widget.replyDirectly
                                                    ? 10.h
                                                    : 100.w - 80,
                                            height: widget.sharing
                                                ? 16.h
                                                : widget.replyDirectly
                                                    ? 10.h
                                                    : 20.h,
                                            fit: BoxFit.cover,
                                            image: ResizeImage(
                                              CachedNetworkImageProvider(
                                                postImgUrl.value,
                                              ),
                                              width: 550,
                                              height: 302,
                                            ),
                                          ),
                                        ),
                                )
                              : Container(),
                          SizedBox(height: 1.h),
                          widget.publication.sharing != null &&
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: CardPostComponent(
                                        publication: widget
                                            .publication.sharing!.publication,
                                        sharing: true,
                                        replyScreen: widget.replyScreen,
                                        replyDirectly: false,
                                        replyPublication:
                                            widget.replyPublication,
                                        contador: widget.contador + 1,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                  ],
                                )
                              : Container(),
                          widget.sharing
                              ? Container()
                              : widget.replyDirectly
                                  ? Container()
                                  : SizedBox(
                                      width: 100.w - 160,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await Get.toNamed(
                                                    '/publish',
                                                    arguments: {
                                                      'commenting':
                                                          widget.publication,
                                                      'sharing': null,
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.messenger_outline,
                                                  size:
                                                      widget.sharing ? 10 : 15,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Obx(
                                                () => Text(
                                                  widget.publication.comments
                                                      .toString(),
                                                  style: widget.sharing
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
                                                    '/publish',
                                                    arguments: {
                                                      'commenting': null,
                                                      'sharing':
                                                          widget.publication,
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.repeat,
                                                  size:
                                                      widget.sharing ? 10 : 15,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Obx(
                                                () => Text(
                                                  widget.publication.sharings
                                                      .toString(),
                                                  style: widget.sharing
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
                                                    _likeController
                                                        .checkLikes(
                                                          user: _loginController
                                                              .userLogged.first,
                                                          publication: widget
                                                              .publication,
                                                          createDelete: true,
                                                          context: context,
                                                        )
                                                        .then((value) =>
                                                            like.value =
                                                                !like.value);
                                                  },
                                                  child: Icon(
                                                    like.isTrue
                                                        ? CupertinoIcons
                                                            .heart_fill
                                                        : CupertinoIcons.heart,
                                                    size: widget.sharing
                                                        ? 10
                                                        : 15,
                                                    color: like.isTrue
                                                        ? Colors.red
                                                        : Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  widget.publication.likes
                                                      .toString(),
                                                  style: widget.sharing
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
          ],
        ),
      ),
    );
  }
}
