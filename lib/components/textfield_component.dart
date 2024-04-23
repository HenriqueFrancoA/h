import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final bool? obscureText;
  final Color? color;
  final int? maxLength;

  const TextFieldComponent({
    super.key,
    required this.labelText,
    this.controller,
    this.width,
    this.height,
    this.obscureText,
    this.color,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60,
      width: width ?? 55,
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        style: Theme.of(context).textTheme.labelMedium,
        maxLength: maxLength,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Colors.grey,
              ),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        controller: controller,
        cursorColor: Colors.white,
      ),
    );
  }
}
