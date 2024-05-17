import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BottomBarComponent extends StatelessWidget {
  final RxBool showBar;
  final int index;
  const BottomBarComponent({
    super.key,
    required this.showBar,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () => AnimatedOpacity(
          opacity: showBar.isTrue ? 1.0 : 0.93,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 100.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              border: const Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            index == 0 ? null : Get.offAllNamed('/home'),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            index == 1 ? null : Get.offAllNamed('/search'),
                        child: const Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            index == 2 ? null : Get.offAllNamed('/config'),
                        child: const Icon(
                          CupertinoIcons.gear,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () =>
                      //       index == 3 ? null : Get.offAllNamed('/message'),
                      //   child: const Icon(
                      //     Icons.message,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      // ),
                    ],
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
