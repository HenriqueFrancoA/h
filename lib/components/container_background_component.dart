import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContainerBackgroundComponent extends StatefulWidget {
  final Widget widget;
  final double? padding;

  const ContainerBackgroundComponent({
    super.key,
    required this.widget,
    this.padding,
  });

  @override
  State<ContainerBackgroundComponent> createState() =>
      _ContainerBackgroundComponentState();
}

class _ContainerBackgroundComponentState
    extends State<ContainerBackgroundComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: EdgeInsets.all(widget.padding ?? 0),
      child: widget.widget,
    );
  }
}
