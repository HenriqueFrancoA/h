import 'package:flutter/material.dart';

class CustomButton extends MaterialButton {
  CustomButton({
    Key? key,
    required VoidCallback onPressed,
    String? text,
    Color? color,
    Color? textColor,
    IconData? icon,
    double? fontSize,
    double? borderRadius,
    required BuildContext context,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: icon != null
              ? Icon(
                  icon,
                  size: 30,
                  color: textColor ?? Colors.white,
                )
              : Text(
                  text ?? '',
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize ?? 16,
                  ),
                ),
          color: color ?? Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
        );
}
