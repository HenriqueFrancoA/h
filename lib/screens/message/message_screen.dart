import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/card_message_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/login_controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  RxBool showBar = RxBool(true);
  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                Column(
                  children: [
                    Container(
                      height: 10.h,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
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
                                  : UserDefaultImageComponent(),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Image.asset(
                              "assets/images/logoBranco.png",
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 90.w,
                      height: 50,
                      child: const TextFieldComponent(
                        labelText: 'Usuário',
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      width: 100.w,
                      height: 0.3,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 90.w,
                        height: 70.h,
                        child: ListView.separated(
                          itemCount: 25,
                          itemBuilder: (context, index) {
                            return const CardMessageComponent();
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BottomBarComponent(
                  showBar: showBar,
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
