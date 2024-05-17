import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CircularProgressComponent extends StatefulWidget {
  final RxBool loading;

  const CircularProgressComponent({
    super.key,
    required this.loading,
  });

  @override
  State<CircularProgressComponent> createState() =>
      _CircularProgressComponentState();
}

class _CircularProgressComponentState extends State<CircularProgressComponent> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.loading.isTrue
          ? Container(
              width: 100.w,
              height: 100.h,
              color: Colors.black87,
              child: const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
