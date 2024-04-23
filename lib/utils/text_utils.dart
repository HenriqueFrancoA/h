import 'package:flutter/material.dart';

TextSpan buildTextSpan(String text, BuildContext context) {
  final List<InlineSpan> children = [];

  final RegExp regex = RegExp(r'[@#](\w+)');

  final matches = regex.allMatches(text);

  int start = 0;
  for (final match in matches) {
    if (match.start > start) {
      children.add(
        TextSpan(
          text: text.substring(start, match.start),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    }

    children.add(
      TextSpan(
        text: match.group(0),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  return TextSpan(children: children);
}
