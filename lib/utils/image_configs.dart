import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:h/models/user.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat('dd MMMM yyyy');

//Faz com que os arquivos do dispositivo para que o usuário selecione uma imagem.
Future<File?> getImage(
  bool croppedImage,
  bool capa,
) async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    if (croppedImage) {
      File? croppedImage = await cropImage(XFile(image.path), capa);
      return croppedImage;
    } else {
      File img = File(image.path);
      return img;
    }
  }
  return null;
}

//Permite o usuário recortar a imagem para o padrão solicitado.
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

//Baixa uma imagem do 'firebase storage'.
Future<String> downloadImages(String pathImage) async {
  late Reference storageRef;
  storageRef = FirebaseStorage.instance.ref().child(pathImage);
  String url = await storageRef.getDownloadURL();
  return url;
}

//Envia uma imagem para o 'firebase storage'.
Future<bool> uploadImage({
  required String pathInput,
  required String pathExit,
  required User user,
  required BuildContext context,
}) async {
  File file = File(pathInput);
  String ref = '';

  try {
    ref = '$pathExit.jpeg';

    final storageRef = FirebaseStorage.instance.ref();
    storageRef.child(ref).delete();
    storageRef.child(ref).putFile(
          file,
          SettableMetadata(
            cacheControl: "public, max-age=600",
            contentType: "image/jpeg",
            customMetadata: {
              user.userName: _dateFormat.format(DateTime.now()),
            },
          ),
        );
    return true;
  } on FirebaseException catch (e) {
    NotificationSnackbar.showError(context, e.message ?? 'Ocorreu algum erro.');
    return false;
  }
}
