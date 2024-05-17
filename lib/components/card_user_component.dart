import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/button_components.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/relation_controller.dart';
import 'package:h/models/user.dart';
import 'package:h/utils/image_configs.dart';
import 'package:h/utils/text_utils.dart';

class CardUserComponent extends StatefulWidget {
  final User user;
  const CardUserComponent({
    super.key,
    required this.user,
  });

  @override
  State<CardUserComponent> createState() => _CardUserComponentState();
}

class _CardUserComponentState extends State<CardUserComponent> {
  late RxString userImgURL = ''.obs;

  RxBool following = RxBool(false);

  final _loginController = Get.put(LoginController());
  final _relationController = Get.put(RelationController());

  @override
  void initState() {
    super.initState();
    pegarUrl();
    checkRelation(false);
  }

  pegarUrl() async {
    if (widget.user.userImage) {
      userImgURL.value = await downloadImages("USER/${widget.user.id}.jpeg");
    }
  }

  Future<bool> checkRelation(bool createDelete) async {
    following.value = await _relationController.checkHasRelation(
      following: _loginController.userLogged.first,
      user: widget.user,
      createDelete: createDelete,
      context: context,
    );
    return following.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/profile/${widget.user.id}',
        arguments: {
          'user': widget.user,
        },
      ),
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: widget.user.userImage
                  ? widget.user.userName ==
                          _loginController.userLogged.first.userName
                      ? Image(
                          width: 50,
                          height: 50,
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
                          () => userImgURL.value.isEmpty
                              ? Container(
                                  width: 50,
                                  height: 50,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                )
                              : Image(
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  image: ResizeImage(
                                    CachedNetworkImageProvider(
                                      userImgURL.value,
                                    ),
                                    width: 156,
                                    height: 275,
                                  ),
                                ),
                        )
                  : UserDefaultImageComponent(),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.userName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    width: 100.w - 180,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          buildTextSpan(
                            widget.user.biography ?? '',
                            context,
                            null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.user.userName != _loginController.userLogged.first.userName
                ? SizedBox(
                    width: 100,
                    height: 35,
                    child: Obx(
                      () => CustomButtonComponent(
                        onPressed: () async {
                          bool retorno = await checkRelation(true);
                          if (retorno) {
                            following.value = !following.value;
                          }
                        },
                        context: context,
                        text: following.value ? 'following' : 'follow',
                        fontSize: 11,
                        color: following.value
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
