import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:h/controllers/relation_controller.dart';
import 'package:h/models/user.dart';
import 'package:h/screens/profile/edit_profile_screen.dart';
import 'package:h/utils/image_configs.dart';
import 'package:h/utils/text_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = Get.arguments['user'] as User?;

  RxBool showBar = RxBool(true);
  RxBool scrollable = RxBool(false);
  RxBool editProfile = RxBool(false);
  RxBool following = RxBool(false);

  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  ScrollController scrollController = ScrollController();

  final _publicationController = Get.put(PublicationController());
  final _relationController = Get.put(RelationController());
  final _loginController = Get.put(LoginController());

  final _dateFormat = DateFormat('dd MMMM yyyy');

  User? userProfile;

  late RxString coverImgUrl = ''.obs;
  late RxString userImgUrl = ''.obs;

  bool waintingResponse = false;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();

    if (user != null) {
      userProfile = User(
        id: user!.id,
        uId: user!.uId,
        email: user!.email,
        userName: user!.userName,
        password: user!.password,
        biography: user!.biography,
        location: user!.location,
        telephone: user!.telephone,
        dateBirth: user!.dateBirth,
        creationDate: user!.creationDate,
        followers: user!.followers,
        following: user!.following,
        userImage: user!.userImage,
        updatedUserImage: user!.updatedUserImage,
        coverImage: user!.coverImage,
        updatedCoverImage: user!.updatedCoverImage,
        disabled: user!.disabled,
      );
      getUrls();
      checkFollow();
    } else {
      userProfile = User(
        id: _loginController.userLogged.first.id,
        uId: _loginController.userLogged.first.uId,
        email: _loginController.userLogged.first.email,
        userName: _loginController.userLogged.first.userName,
        password: _loginController.userLogged.first.password,
        biography: _loginController.userLogged.first.biography,
        location: _loginController.userLogged.first.location,
        telephone: _loginController.userLogged.first.telephone,
        dateBirth: _loginController.userLogged.first.dateBirth,
        creationDate: _loginController.userLogged.first.creationDate,
        followers: _loginController.userLogged.first.followers,
        following: _loginController.userLogged.first.following,
        userImage: _loginController.userLogged.first.userImage,
        updatedUserImage: _loginController.userLogged.first.updatedUserImage,
        coverImage: _loginController.userLogged.first.coverImage,
        updatedCoverImage: _loginController.userLogged.first.updatedCoverImage,
        disabled: _loginController.userLogged.first.disabled,
      );
    }
    _publicationController.searchByUser(null, userProfile!, context);
  }

  checkFollow() async {
    following.value = await _relationController.checkHasRelation(
      following: user!,
      user: _loginController.userLogged.first,
      createDelete: false,
      context: context,
    );
  }

  void getUrls() async {
    if (user!.coverImage) {
      coverImgUrl.value = await downloadImages("COVER/${user!.id}.jpeg");
    }
    if (user!.userImage) {
      userImgUrl.value = await downloadImages("USER/${user!.id}.jpeg");
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() async {
    final isLastWidgetVisible = scrollController.position.pixels <= 25.h;

    scrollable.value = !isLastWidgetVisible;

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      showBar.value = false;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      showBar.value = true;
    }

    if (scrollController.position.maxScrollExtent == scrollController.offset &&
        !waintingResponse) {
      if (_publicationController.finalListUser.containsKey(userProfile!.id) &&
          _publicationController.finalListUser[userProfile!.id]! == false) {
        waintingResponse = true;
        await _publicationController.searchByUser(
          _publicationController.mapUserPublication[userProfile!.id]!.last,
          userProfile!,
          context,
        );
        waintingResponse = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: ContainerBackgroundComponent(
          widget: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: 25.h,
                      child: Stack(
                        children: [
                          userProfile!.coverImage
                              ? Obx(
                                  () => Container(
                                      color: Colors.transparent,
                                      child: user == null ||
                                              (user != null &&
                                                  user!.userName ==
                                                      _loginController
                                                          .userLogged
                                                          .first
                                                          .userName)
                                          ? Image(
                                              image: ResizeImage(
                                                FileImage(
                                                  File(
                                                    _loginController
                                                        .coverImage.value,
                                                  ),
                                                ),
                                                width: 486,
                                                height: 864,
                                              ),
                                              width: 100.w,
                                              height: 18.h,
                                              fit: BoxFit.cover,
                                            )
                                          : coverImgUrl.value.isEmpty
                                              ? Container(
                                                  width: 100.w,
                                                  height: 18.h,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                )
                                              : Image(
                                                  image: ResizeImage(
                                                    CachedNetworkImageProvider(
                                                        coverImgUrl.value),
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
                                onTap: () => Get.back(),
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
                                color: Theme.of(context).colorScheme.background,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: GestureDetector(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: userProfile!.userImage
                                      ? user == null ||
                                              (user != null &&
                                                  user!.userName ==
                                                      _loginController
                                                          .userLogged
                                                          .first
                                                          .userName)
                                          ? Image(
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                FileImage(
                                                  File(
                                                    _loginController
                                                        .userImage.value,
                                                  ),
                                                ),
                                                width: 156,
                                                height: 275,
                                              ),
                                            )
                                          : Obx(
                                              () => userImgUrl.value.isEmpty
                                                  ? Container(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    )
                                                  : Image(
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
                                      : UserDefaultImageComponent(),
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
                                      userProfile!.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    user == null ||
                                            (user != null &&
                                                user!.userName ==
                                                    _loginController.userLogged
                                                        .first.userName)
                                        ? CustomButtonComponent(
                                            onPressed: () =>
                                                editProfile.value = true,
                                            context: context,
                                            text: 'Editar Perfil',
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          )
                                        : Obx(
                                            () => CustomButtonComponent(
                                              onPressed: () async {
                                                bool retorno =
                                                    await _relationController
                                                        .checkHasRelation(
                                                  following: user!,
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
                                              text: following.value
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
                          userProfile!.biography != null &&
                                  userProfile!.biography!.isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: 100.w,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            buildTextSpan(
                                              userProfile!.biography!,
                                              context,
                                              null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                  ],
                                )
                              : Container(),
                          userProfile!.location != null &&
                                  userProfile!.location!.isNotEmpty
                              ? Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_solid,
                                      size: 13,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      userProfile!.location!,
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
                            'criado em ${_dateFormat.format(userProfile!.creationDate.toDate())}',
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
                              GestureDetector(
                                onTap: () => Get.toNamed(
                                  '/users',
                                  arguments: {
                                    'user': userProfile,
                                    'following': false,
                                  },
                                ),
                                child: Row(
                                  children: [
                                    Obx(
                                      () => Text(
                                        userProfile!.followers.toString(),
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
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w),
                              GestureDetector(
                                onTap: () => Get.toNamed(
                                  '/users',
                                  arguments: {
                                    'user': userProfile,
                                    'following': true,
                                  },
                                ),
                                child: Row(
                                  children: [
                                    Obx(
                                      () => Text(
                                        userProfile!.following.toString(),
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      height: 0.1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 100.w,
                      child: Obx(
                        () => ListView.separated(
                          itemCount: _publicationController
                                      .mapUserPublication[userProfile!.id] !=
                                  null
                              ? _publicationController
                                      .mapUserPublication[userProfile!.id]!
                                      .length +
                                  1
                              : 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index ==
                                _publicationController
                                    .mapUserPublication[userProfile!.id]!
                                    .length) {
                              return FutureBuilder(
                                future:
                                    Future.delayed(const Duration(seconds: 3)),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      height: 15.h,
                                      padding: const EdgeInsets.all(5),
                                      child: const Align(
                                        alignment: Alignment.topCenter,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 15.h,
                                    );
                                  }
                                },
                              );
                            }

                            return CardPostComponent(
                              publication: _publicationController
                                  .mapUserPublication[userProfile!.id]![index],
                              sharing: false,
                              replyScreen: false,
                              replyDirectly: false,
                              replyPublication: false,
                              contador: 0,
                            );
                          },
                          separatorBuilder: (context, index) => Container(
                            width: 100.w,
                            height: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
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
                                    onTap: () => Get.back(),
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  userProfile!.userName,
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
                showBar: showBar,
                index: 9,
              ),
              Obx(
                () => editProfile.isFalse
                    ? Container()
                    : EditProfileScreen(
                        onTap: () => editProfile.value = false,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
