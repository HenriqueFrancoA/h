import 'package:flutter/material.dart';

//Cria uma área de texto flexível com a largura da tela.
TextSpan buildTextSpan(
  String text,
  BuildContext context,
  TextStyle? textStyle,
) {
  final List<InlineSpan> children = [];

  final RegExp regex = RegExp(r'[@#](\w+)');

  final matches = regex.allMatches(text);

  int start = 0;
  for (final match in matches) {
    if (match.start > start) {
      children.add(
        TextSpan(
          text: text.substring(start, match.start),
          style: textStyle ?? Theme.of(context).textTheme.labelSmall,
        ),
      );
    }

    children.add(
      TextSpan(
        text: match.group(0),
        style: textStyle ??
            Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
    start = match.end;
  }

  if (start < text.length) {
    children.add(
      TextSpan(
        text: text.substring(start),
        style: textStyle ?? Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  return TextSpan(children: children);
}
