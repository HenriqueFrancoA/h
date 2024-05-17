import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/button_components.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:h/models/publication.dart';
import 'package:h/utils/converter_time.dart';
import 'package:h/utils/image_configs.dart';
import 'package:h/utils/text_utils.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({Key? key}) : super(key: key);

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  Publication? commenting = Get.arguments['commenting'];
  Publication? sharing = Get.arguments['sharing'];

  final textController = TextEditingController();

  final _loginController = Get.put(LoginController());
  final _publicationController = Get.put(PublicationController());

  late FocusNode focusNode;

  XFile? image;
  File? file;
  RxBool selectedImage = RxBool(false);

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
        body: ContainerBackgroundComponent(
          widget: Stack(
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
                                commenting != null
                                    ? Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: UserDefaultImageComponent(
                                              width: 30,
                                              height: 30,
                                              widthQuality: 78,
                                              heightQuality: 137,
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
                                  child: _loginController
                                          .userLogged.first.userImage
                                      ? Image(
                                          width: 30,
                                          height: 30,
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
                                      : UserDefaultImageComponent(
                                          width: 30,
                                          height: 30,
                                          widthQuality: 78,
                                          heightQuality: 138,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commenting != null
                                  ? Column(
                                      children: [
                                        CardPostComponent(
                                          key: _cardPostKey,
                                          publication: commenting!,
                                          sharing: false,
                                          replyScreen: false,
                                          replyDirectly: true,
                                          replyPublication: false,
                                          contador: 0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            width: 100.w - 90,
                                            child: Text(
                                              'Respondendo - @${commenting!.user.userName}',
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
                                  horizontal: 10.0,
                                ),
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
                                        controller: textController,
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
                                  horizontal: 20.0,
                                ),
                                child: Obx(
                                  () => selectedImage.isTrue
                                      ? Container(
                                          width: 100.w - 100,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            image: DecorationImage(
                                              image: ResizeImage(
                                                FileImage(
                                                  file!,
                                                ),
                                                width: 550,
                                                height: 312,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ),
                              sharing != null
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
                                                child:
                                                    UserDefaultImageComponent(
                                                  width: 30,
                                                  height: 30,
                                                  widthQuality: 78,
                                                  heightQuality: 138,
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              Text(
                                                sharing!.user.userName,
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
                                                timeSinceCreation(
                                                    sharing!.creationDate),
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
                                                    sharing!.text ?? '',
                                                    context,
                                                    null,
                                                  ),
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
                    CustomButtonComponent(
                      onPressed: () {
                        _publicationController
                            .create(
                          user: _loginController.userLogged.first,
                          image: selectedImage.value,
                          sharedPublication: sharing,
                          text: textController.text,
                          context: context,
                          commenting: commenting,
                          imagePath: file != null ? file!.path : '',
                        )
                            .then(
                          (response) {
                            if (response) {
                              Get.back();
                            }
                          },
                        );
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
                      (image) {
                        if (image != null) {
                          selectedImage.value = true;
                          file = image;
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
