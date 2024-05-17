// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class UserDefaultImageComponent extends StatelessWidget {
  double? width;
  double? height;
  int? widthQuality;
  int? heightQuality;
  UserDefaultImageComponent({
    Key? key,
    this.width,
    this.height,
    this.widthQuality,
    this.heightQuality,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      width: width ?? 50,
      height: height ?? 50,
      fit: BoxFit.cover,
      image: ResizeImage(
        const AssetImage(
          "assets/images/perfil.png",
        ),
        width: widthQuality ?? 156,
        height: heightQuality ?? 275,
      ),
    );
  }
}
