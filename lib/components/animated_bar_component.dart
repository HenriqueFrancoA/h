import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:sizer/sizer.dart';

class AnimatedBarComponent extends StatelessWidget {
  final RxBool showBar;
  final bool getBack;
  final FocusNode? focusNode;
  final bool hasFocus;
  final bool searched;
  final VoidCallback? onTapPublish;
  final Function(String)? onSubmitted;
  final VoidCallback? onTapCancel;
  final TextEditingController? textController;

  const AnimatedBarComponent({
    super.key,
    required this.showBar,
    this.onTapPublish,
    required this.getBack,
    this.focusNode,
    required this.hasFocus,
    this.textController,
    this.onSubmitted,
    required this.searched,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return Obx(
      () => AnimatedOpacity(
        opacity: showBar.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 100.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: const Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: searched || hasFocus
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              searched || hasFocus
                  ? Container()
                  : getBack
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Get.toNamed(
                            '/profile/${loginController.userLogged.first.id}',
                            arguments: {
                              'user': null,
                            },
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: loginController.userLogged.first.userImage
                                ? Image(
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                    image: ResizeImage(
                                      FileImage(
                                        File(
                                          loginController.userImage.value,
                                        ),
                                      ),
                                      width: 156,
                                      height: 275,
                                    ),
                                  )
                                : UserDefaultImageComponent(
                                    width: 30,
                                    height: 30,
                                    widthQuality: 78,
                                    heightQuality: 138,
                                  ),
                          ),
                        ),
              focusNode != null
                  ? TextFieldComponent(
                      focusNode: focusNode,
                      controller: textController,
                      hintText: 'Buscar',
                      width: 60.w,
                      onSubmitted: onSubmitted,
                    )
                  : SizedBox(
                      width: 30,
                      child: Image.asset(
                        "assets/images/logoBranco.png",
                      ),
                    ),
              searched || focusNode != null
                  ? Row(
                      children: [
                        SizedBox(width: 5.w),
                        Visibility(
                          visible: searched || hasFocus,
                          child: GestureDetector(
                            onTap: onTapCancel,
                            child: Text(
                              'Cancelar',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ],
                    )
                  : onTapPublish != null
                      ? GestureDetector(
                          onTap: onTapPublish,
                          child: const Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      : Container(
                          width: hasFocus ? 0 : 30,
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
