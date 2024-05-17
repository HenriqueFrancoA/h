import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/animated_bar_component.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/card_user_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/controllers/relation_controller.dart';
import 'package:h/models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final user = Get.arguments['user'] as User;
  final following = Get.arguments['following'] as bool;

  RxBool showBar = RxBool(true);

  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final _relationController = Get.put(RelationController());

  @override
  void initState() {
    super.initState();
    _relationController.searchByRelation(
      user: user,
      following: following,
      context: context,
    );
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
                  width: 100.w,
                  height: 100.h,
                  child: Obx(
                    () => ListView.separated(
                      itemCount: _relationController.listRelation.length + 1,
                      itemBuilder: (context, index) {
                        index = index - 1;
                        return index < 0
                            ? SizedBox(
                                height: 10.h,
                              )
                            : CardUserComponent(
                                user: following
                                    ? _relationController
                                        .listRelation[index].following
                                    : _relationController
                                        .listRelation[index].user,
                              );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 2.h,
                      ),
                    ),
                  ),
                ),
                AnimatedBarComponent(
                  showBar: showBar,
                  getBack: true,
                  hasFocus: false,
                  searched: false,
                ),
                BottomBarComponent(
                  showBar: showBar,
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
