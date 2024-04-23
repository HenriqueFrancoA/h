import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BottomBarComponent extends StatelessWidget {
  final RxBool mostrarBarra;
  final int index;
  const BottomBarComponent({
    super.key,
    required this.mostrarBarra,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () => AnimatedOpacity(
          opacity: mostrarBarra.isTrue ? 1.0 : 0.93,
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
                        onTap: () {},
                        child: const Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          CupertinoIcons.bell_fill,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            index == 3 ? null : Get.offAllNamed('/mensagem'),
                        child: const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
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
