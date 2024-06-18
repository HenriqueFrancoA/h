import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final double? width;
  final bool? obscureText;
  final Color? borderColor;
  final Color? color;
  final int? maxLength;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final VoidCallback? tapObscure;

  const TextFieldComponent({
    super.key,
    this.labelText,
    this.controller,
    this.width,
    this.obscureText,
    this.color,
    this.maxLength,
    this.focusNode,
    this.hintText,
    this.onSubmitted,
    this.borderColor,
    this.tapObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 55,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(5),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
              )
            : null,
      ),
      child: TextField(
        focusNode: focusNode,
        style: Theme.of(context).textTheme.labelSmall,
        maxLength: maxLength,
        maxLines: 1,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Colors.grey,
              ),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Colors.grey,
              ),
          suffixIcon: obscureText != null
              ? GestureDetector(
                  onTap: tapObscure,
                  child: Icon(
                    obscureText!
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        cursorColor: Colors.white,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
