import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConfigButtonComponent extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const ConfigButtonComponent({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<ConfigButtonComponent> createState() => _ConfigButtonComponentState();
}

class _ConfigButtonComponentState extends State<ConfigButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 100.w,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
