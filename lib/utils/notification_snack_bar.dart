import 'package:flutter/material.dart';

//Cria uma barra de notificação temporária na tela.
class NotificationSnackbar {
  static void show({
    required BuildContext context,
    required String text,
    Color backgroundColor = Colors.green,
    TextStyle? textStyle,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(5)),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: textStyle),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context: context,
      text: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      textStyle: Theme.of(context).textTheme.bodySmall,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      text: message,
      backgroundColor: Colors.green,
      textStyle: Theme.of(context).textTheme.bodySmall,
    );
  }
}
