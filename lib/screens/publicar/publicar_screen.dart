import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/button_components.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/utils/get_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class PublicarScreen extends StatefulWidget {
  const PublicarScreen({Key? key}) : super(key: key);

  @override
  State<PublicarScreen> createState() => _PublicarScreenState();
}

class _PublicarScreenState extends State<PublicarScreen> {
  final TextEditingController textEditingController = TextEditingController();

  final loginController = Get.put(LoginController());

  late FocusNode focusNode;

  XFile? image;
  File? file;
  RxBool imagemSelecionada = RxBool(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus(FocusNode());
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
              Container(
                width: 100.w,
                height: 10.h,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      onPressed: () {},
                      context: context,
                      text: 'Publicar',
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      File(loginController.imagemUsuario.value),
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
                                      "assets/images/post01.png",
                                    ),
                                    width: 130,
                                    height: 240,
                                  ),
                                ),
                        ),
                        SizedBox(width: 2.w),
                        SizedBox(
                          width: 95.w - 50,
                          child: TextField(
                            autofocus: true,
                            focusNode: focusNode,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Escreva sua publicação...',
                              border: InputBorder.none,
                              hintStyle: Theme.of(context).textTheme.labelSmall,
                            ),
                            style: Theme.of(context).textTheme.labelMedium,
                            cursorColor: Colors.white,
                            minLines: 2,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => imagemSelecionada.isTrue
                        ? Container(
                            width: 100.w - 80,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
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
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () async =>
                            await getImage(false, false).then(
                          (imagem) {
                            if (imagem != null) {
                              imagemSelecionada.value = true;
                              file = imagem;
                            }
                          },
                        ),
                      ),
                    ],
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
