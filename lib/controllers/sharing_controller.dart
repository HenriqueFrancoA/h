// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:h/apis/sharing_api.dart';
import 'package:h/models/dto/sharing_dto.dart';
import 'package:h/models/publication.dart';
import 'package:h/models/sharing.dart';
import 'package:h/utils/internet_verify.dart';
import 'package:h/utils/notification_snack_bar.dart';

class SharingController extends GetxController {
  final _internet = Internet();

  final SharingApi _sharingApi = SharingApi();

  //Cria um novo 'Sharing'.
  Future<Sharing?> create({
    required Publication publication,
    required BuildContext context,
  }) async {
    if (!await _internet.checkConnection(context)) {
      return null;
    }

    try {
      var db = FirebaseFirestore.instance;

      SharingDto sharingDto = SharingDto(
        publication: db.doc("PUBLICATION/${publication.id}"),
      );

      String id = await _sharingApi.create(sharingDto);

      if (id != '') {
        Sharing sharing = Sharing(
          id: id,
          publication: publication,
        );
        return sharing;
      }
      return null;
    } on FirebaseException catch (e) {
      NotificationSnackbar.showError(
          context, e.message ?? 'Ocorreu algum erro.');
      return null;
    }
  }
}
