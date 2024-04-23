import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> getImage(
  bool imagemRecortada,
  bool capa,
) async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    if (imagemRecortada) {
      File? croppedImage = await cropImage(XFile(image.path), capa);
      return croppedImage;
    } else {
      File imagem = File(image.path);
      return imagem;
    }
  }
  return null;
}

Future<File?> cropImage(
  XFile imagePath,
  bool capa,
) async {
  final imageCropper = ImageCropper();
  File? croppedImage = await imageCropper.cropImage(
    sourcePath: imagePath.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.ratio16x9,
    ],
    aspectRatio: capa
        ? const CropAspectRatio(ratioX: 16, ratioY: 9)
        : const CropAspectRatio(ratioX: 1, ratioY: 1),
    compressQuality: 100,
    maxHeight: capa ? 243 : 156,
    maxWidth: capa ? 432 : 156,
    androidUiSettings: const AndroidUiSettings(
      toolbarTitle: 'Recortar Imagem',
      toolbarColor: Color.fromARGB(255, 3, 11, 31),
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
      showCropGrid: false,
    ),
    cropStyle: capa ? CropStyle.rectangle : CropStyle.circle,
  );
  return croppedImage;
}
