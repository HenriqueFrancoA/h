// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/models/comment.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/animated_bar_component.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:h/controllers/comment_controller.dart';
import 'package:h/controllers/like_controller.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:h/controllers/relation_controller.dart';
import 'package:h/models/publication.dart';
import 'package:h/utils/image_configs.dart';
import 'package:h/utils/text_utils.dart';

class PublicationScreen extends StatefulWidget {
  const PublicationScreen({super.key});

  @override
  State<PublicationScreen> createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> {
  final publication = Get.arguments['publication'] as Publication;
  Publication? reply = Get.arguments['reply'] as Publication?;

  final textController = TextEditingController();

  RxBool showBar = RxBool(true);
  RxBool keyboardOpen = RxBool(false);
  RxBool liked = RxBool(false);
  RxBool following = RxBool(false);

  RxDouble cardPostHeight = 0.0.obs;
  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  late RxString userImgUrl = ''.obs;
  late RxString userReplyImgUrl = ''.obs;
  late RxString postImgUrl = ''.obs;
  late RxString postReplyImgUrl = ''.obs;

  final GlobalKey _cardPostKey = GlobalKey();

  final _publicationController = Get.put(PublicationController());
  final _commentController = Get.put(CommentController());
  final _likeController = Get.put(LikeController());
  final _loginController = Get.put(LoginController());
  final _relationController = Get.put(RelationController());

  final _dateFormat = DateFormat('hh:mm - dd/MM/yyyy');

  final _textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _textFieldFocus.addListener(() {
      keyboardOpen.value = _textFieldFocus.hasFocus;
    });
    checkLike();
    getUrls();
  }

  void getUrls() async {
    if (publication.user.userImage) {
      userImgUrl.value =
          await downloadImages("USER/${publication.user.id}.jpeg");
    }
    if (publication.image) {
      postImgUrl.value = await downloadImages("POST/${publication.id}.jpeg");
    }
    if (reply == null && publication.comment) {
      Comment? comment =
          await _commentController.searchByReply(publication, context);
      if (comment != null) {
        setState(() {
          reply = comment.publication;
        });
      }
    }

    if (reply != null) {
      if (reply!.user.userImage) {
        userReplyImgUrl.value =
            await downloadImages("USER/${reply!.user.id}.jpeg");
      }
      if (reply!.image) {
        postReplyImgUrl.value = await downloadImages("POST/${reply!.id}.jpeg");
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cardPostKey.currentContext != null) {
        RenderBox cardPostBox =
            _cardPostKey.currentContext!.findRenderObject() as RenderBox;
        cardPostHeight.value = cardPostBox.size.height;
      }
    });
  }

  checkFollow() async {
    following.value = await _relationController.checkHasRelation(
      following: publication.user,
      user: _loginController.userLogged.first,
      createDelete: false,
      context: context,
    );
  }

  checkLike() async {
    liked.value = await _likeController.checkLikes(
      user: _loginController.userLogged.first,
      publication: publication,
      createDelete: false,
      context: context,
    );
  }

  @override
  void dispose() {
    _textFieldFocus.dispose();
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
              showBar.value = false;
            } else {
              showBar.value = true;
            }
            prevScrollPosition = scrollPosition;
            return false;
          },
          child: ContainerBackgroundComponent(
            widget: Stack(
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
                        reply != null
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: publication.disabled
                                    ? const Center(
                                        child: Text(
                                          'Publicação foi removida.',
                                        ),
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: !reply!.user.userImage
                                                      ? UserDefaultImageComponent()
                                                      : Obx(
                                                          () => userReplyImgUrl
                                                                  .value.isEmpty
                                                              ? Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onSecondary,
                                                                )
                                                              : Image(
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      ResizeImage(
                                                                    CachedNetworkImageProvider(
                                                                      userReplyImgUrl
                                                                          .value,
                                                                    ),
                                                                    width: 156,
                                                                    height: 275,
                                                                  ),
                                                                ),
                                                        )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Obx(
                                                () => cardPostHeight.value > 0
                                                    ? Container(
                                                        height: cardPostHeight
                                                                .value -
                                                            25,
                                                        width: 0.5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      )
                                                    : Container(),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          CardPostComponent(
                                            key: _cardPostKey,
                                            publication: reply!,
                                            sharing: false,
                                            replyScreen: false,
                                            replyDirectly: false,
                                            replyPublication: true,
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
                                    child: UserDefaultImageComponent(),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    publication.user.userName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer(),
                                  publication.user.userName !=
                                          _loginController
                                              .userLogged.first.userName
                                      ? CustomButtonComponent(
                                          onPressed: () async {
                                            bool retorno =
                                                await _relationController
                                                    .checkHasRelation(
                                              following: publication.user,
                                              user: _loginController
                                                  .userLogged.first,
                                              createDelete: true,
                                              context: context,
                                            );
                                            if (retorno) {
                                              following.value =
                                                  !following.value;
                                            }
                                          },
                                          context: context,
                                          text: following.isTrue
                                              ? 'following'
                                              : 'follow',
                                          fontSize: 11,
                                          color: following.value
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                        )
                                      : publication.disabled
                                          ? Container()
                                          : PopupMenuButton<String>(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        _publicationController
                                                            .delete(
                                                      publication,
                                                      context,
                                                    )
                                                            .then(
                                                      (response) {
                                                        if (response) {
                                                          Get.back();
                                                          Get.back();
                                                        }
                                                      },
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .delete_outline_outlined,
                                                          color: Colors.red,
                                                          size: 13,
                                                        ),
                                                        SizedBox(width: 2.w),
                                                        Text(
                                                          'Excluir',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelSmall!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              child: const Icon(
                                                CupertinoIcons
                                                    .ellipsis_vertical,
                                                color: Colors.white,
                                              ),
                                            ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              publication.disabled
                                  ? Center(
                                      child: SizedBox(
                                        width: 100.w,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              buildTextSpan(
                                                'Essa publicação foi removida pelo o usuário.',
                                                context,
                                                Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                buildTextSpan(
                                                  publication.text ?? '',
                                                  context,
                                                  null,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        publication.image
                                            ? Column(
                                                children: [
                                                  Obx(
                                                    () => postImgUrl
                                                            .value.isEmpty
                                                        ? Container(
                                                            width: 100.w,
                                                            height: 25.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image(
                                                              width: 100.w,
                                                              height: 25.h,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  ResizeImage(
                                                                CachedNetworkImageProvider(
                                                                  postImgUrl
                                                                      .value,
                                                                ),
                                                                width: 550,
                                                                height: 302,
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                ],
                                              )
                                            : Container(),
                                        SizedBox(height: 1.h),
                                        publication.sharing != null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.2,
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child:
                                                          UserDefaultImageComponent(
                                                        width: 30,
                                                        height: 30,
                                                        widthQuality: 78,
                                                        heightQuality: 137,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    CardPostComponent(
                                                      publication: publication
                                                          .sharing!.publication,
                                                      sharing: false,
                                                      replyScreen: false,
                                                      replyDirectly: false,
                                                      replyPublication: true,
                                                      contador: 1,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                              SizedBox(height: 1.h),
                              Text(
                                _dateFormat.format(
                                  publication.creationDate.toDate(),
                                ),
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
                                        publication.comments.toString(),
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
                                        publication.sharings.toString(),
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
                                          publication.likes.toString(),
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
                              publication.disabled
                                  ? Container()
                                  : Column(
                                      children: [
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
                                                  _textFieldFocus
                                                      .requestFocus();
                                                },
                                                child: const Icon(
                                                  Icons.messenger_outline,
                                                  size: 20,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await Get.toNamed(
                                                    '/publish',
                                                    arguments: {
                                                      'commenting': null,
                                                      'sharing': publication,
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
                                                  _likeController
                                                      .checkLikes(
                                                        user: _loginController
                                                            .userLogged.first,
                                                        publication:
                                                            publication,
                                                        createDelete: true,
                                                        context: context,
                                                      )
                                                      .then((value) =>
                                                          liked.value =
                                                              !liked.value);
                                                },
                                                child: Obx(
                                                  () => Icon(
                                                    liked.isTrue
                                                        ? CupertinoIcons
                                                            .heart_fill
                                                        : CupertinoIcons.heart,
                                                    size: 20,
                                                    color: liked.isTrue
                                                        ? Colors.red
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                          future: _commentController.searchByPublication(
                            publication,
                            context,
                          ),
                          builder: (context, snapshot) {
                            return SizedBox(
                              width: 100.w,
                              height: 100.h,
                              child: ListView.separated(
                                itemCount: _commentController
                                                .mapPublicationComments[
                                            publication.id] !=
                                        null
                                    ? _commentController
                                        .mapPublicationComments[publication.id]!
                                        .length
                                    : 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CardPostComponent(
                                    publication: _commentController
                                        .mapPublicationComments[
                                            publication.id]![index]
                                        .reply,
                                    sharing: false,
                                    replyScreen: true,
                                    replyDirectly: false,
                                    reply: publication,
                                    replyPublication: false,
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
                AnimatedBarComponent(
                  showBar: showBar,
                  getBack: true,
                  hasFocus: false,
                  searched: false,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: publication.disabled ? 10.h : 22.h,
                    color: Theme.of(context).colorScheme.onBackground,
                    child: Column(
                      children: [
                        publication.disabled
                            ? Container()
                            : Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                margin: const EdgeInsets.all(10),
                                child: Obx(
                                  () => TextField(
                                    controller: textController,
                                    focusNode: _textFieldFocus,
                                    decoration: InputDecoration(
                                      hintText: 'Sua resposta...',
                                      border: InputBorder.none,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                    cursorColor: Colors.white,
                                    minLines: 1,
                                    maxLines: keyboardOpen.isTrue ? 4 : 1,
                                  ),
                                ),
                              ),
                        Obx(
                          () => keyboardOpen.isTrue
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          textController.clear();
                                          _textFieldFocus.unfocus();
                                          setState(() {});
                                          await Get.toNamed(
                                            '/publish',
                                            arguments: {
                                              'commenting': publication,
                                              'sharing': null,
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          CupertinoIcons.fullscreen,
                                        ),
                                      ),
                                      CustomButtonComponent(
                                        text: 'Comentar',
                                        onPressed: () {
                                          _publicationController
                                              .create(
                                            user: _loginController
                                                .userLogged.first,
                                            image: false,
                                            sharedPublication: null,
                                            text: textController.text,
                                            context: context,
                                            commenting: publication,
                                          )
                                              .then((response) {
                                            if (response) {}
                                            textController.clear();
                                            _textFieldFocus.unfocus();
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
                                  showBar: showBar,
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
