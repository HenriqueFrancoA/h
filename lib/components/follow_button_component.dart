import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/button_components.dart';

class FollowButtonComponent extends StatefulWidget {
  final RxBool following;
  final RxBool loadingRelation;
  final Future<void> Function(bool createDelete) checkRelation;
  const FollowButtonComponent({
    super.key,
    required this.following,
    required this.checkRelation,
    required this.loadingRelation,
  });

  @override
  State<FollowButtonComponent> createState() => _FollowButtonComponentState();
}

class _FollowButtonComponentState extends State<FollowButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomButtonComponent(
        onPressed: () async {
          widget.loadingRelation.isTrue
              ? null
              : await widget.checkRelation(true);
        },
        context: context,
        text: widget.following.value ? 'seguindo' : 'seguir',
        fontSize: 11,
        color: widget.following.value
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
